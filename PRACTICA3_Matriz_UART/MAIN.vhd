----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:50:42 03/30/2019 
-- Design Name: 
-- Module Name:    MAIN - Behavioral 
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
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MAIN is
Generic(
	Uart_Bits: Natural:=8;
	BaudRate: Integer :=1250
	--Baudrate = (Clock/Baudrate) Example (12MHz/9600)=1250
);

Port(
	CLK:		in		Std_Logic;
	RST:		in		Std_Logic;
	RX:		in		Std_Logic;
	LED:		out	Std_Logic_Vector(7 downto 0);
   Enable:	out	std_logic_vector(7 downto 0);
   Column:  out 	std_logic_vector(7 downto 0)
   );
end MAIN;

architecture Behavioral of MAIN is

Signal Data: 	Std_Logic_Vector(Uart_Bits-1 downto 0); --Almacena el caracter ASCII recibido
Signal Count:	Integer Range 0 to Uart_Bits;
Signal PRSCL:	Integer Range 0 to BaudRate*2;

Type FSM is (Idle, FirstBit, Data_Fetch, Resync);
Signal State : FSM;

signal bus_clk:	   std_logic; --Almacena la señal de reloj
signal bus_enable:	std_logic_vector(7 downto 0);
signal bus_column:	std_logic_vector(7 downto 0);
signal bus_data:	   Std_Logic_Vector(Uart_Bits-1 downto 0); --Almacena el caracter ASCII recibido

component MATRIZ
	Port(
		Clk:		in		std_logic;
		Enable:	out	std_logic_vector(7 downto 0);
		Column:	out	std_logic_vector(7 downto 0);
		Dato:    in    Std_Logic_Vector(7 downto 0)
	);
end component;

Begin

	Inst_MATRIZ: MATRIZ port map(
		Clk => bus_clk,
		Enable => bus_enable,
		Column => bus_column,
		Dato => bus_data
	);
	
	bus_clk <= clk;
	bus_data <= Data; 
	Enable <= bus_enable;
	Column <= bus_column;
	
   LED <= Data; --Se muestra el caracter ASCII en binario en los LEDS
	
	Process(CLK, RST)
		Begin
		
		If(RST = '0') Then
			State<= Idle;
			Count<=0;
			PRSCL<=0;
			Data <= (Others => '0');
		Elsif(Rising_Edge(CLK)) Then
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
		End If;
		
	End Process;

end Behavioral;