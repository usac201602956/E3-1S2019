----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:07:00 03/01/2019 
-- Design Name: 
-- Module Name:    main - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity main is
	Generic(
		Uart_Bits: Natural:=8;
		BaudRate: Integer :=1250
		--Baudrate = (Clock/Baudrate) Example (12MHz/9600)=1250
	);
	Port(
		--Señales de control; reset y señal de reloj.
		clk:		in		std_logic;
		reset:	in		std_logic;
		--Receptor de UART.
		RX:	in		std_logic;
		--Salidas para el control de los Display's.
		Enable:	out	std_logic_vector(2 downto 0);
		Display: out 	std_logic_vector(7 downto 0);
		--
		LED:		out	Std_Logic_Vector(7 downto 0)
	);
end main;

architecture Behavioral of main is
--Senales para el control del RX
	Signal Data: 	Std_Logic_Vector(Uart_Bits-1 downto 0);
	Signal Count:	Integer Range 0 to Uart_Bits;
	Signal PRSCL:	Integer Range 0 to BaudRate*2;
	Type FSM is (Idle, FirstBit, Data_Fetch, Resync);
	Signal State : FSM;
--Implementacion de la memoria.
	Type memoria is array (0 to 10) of Std_Logic_Vector(7 downto 0);
	signal Segmentos: memoria:=("11000000", --0
										 "11111001", --1
										 "10100100", --2
										 "10110000", --3
										 "10011001", --4
										 "10010010", --5
										 "10000010", --6
										 "11111000", --7
										 "10000000", --8
										 "10010000", --9
										 "01111111");--.
	signal numero: integer range 0 to 255;

begin
	
	Enable <= "110";
	numero <= (to_integer(unsigned(Data)));
	
	process(clk, reset)
		begin
		if(reset = '0') then
			State<= Idle;
			Count<=0;
			PRSCL<=0;
			Data <= (Others => '0');
		elsif(rising_edge(clk)) then
			
			Case State is
				When IDLE =>
					Count<=0;
					PRSCL<=0;
					If(RX='0') Then
						State<=FirstBit;
					End If;
					
				When FirstBit =>
					If(PRSCL=BaudRate+(Baudrate/2)) Then
						PRSCL<=0;
						Data(Count)<=RX;
						Count<=Count+1;
						State<=Data_Fetch;
					Else
						PRSCL<=PRSCL+1;
					End If;
											
				When Data_Fetch =>
					IF(PRSCL=BaudRate) Then
						PRSCL<=0;
						IF(Count<Uart_Bits) Then
							Data(Count) <= RX;
							Count<=Count+1;
						Else
							State<=Resync;
						End If;
					Else
						PRSCL<=PRSCL+1;
					End If;
						
				When Resync =>
					If(PRSCL=BaudRate) Then
						PRSCL<=0;
						LED<=Data;
						if(numero > 47 and numero < 58) then
							Display <= Segmentos(numero - 48);
						else
							Display <= Segmentos(10);
						end if;
						State<=IDLE;
					Else
						PRSCL<=PRSCL+1;
					End If;
						
				When Others =>
					PRSCL<=0;
					State<= Idle;
					Count<=0;
					Data <= (Others => '0');
			End Case;
			
		end if;
	end process;

end Behavioral;