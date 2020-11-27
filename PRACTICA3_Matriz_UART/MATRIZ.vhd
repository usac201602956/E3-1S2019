----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:40:51 03/30/2019 
-- Design Name: 
-- Module Name:    MATRIZ - Behavioral 
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

entity MATRIZ is
	Port(
		Clk:		in		std_logic;
		Enable:	out	std_logic_vector(7 downto 0);
		Column:	out	std_logic_vector(7 downto 0);
		Dato:    in    Std_Logic_Vector(7 downto 0)
	);
end MATRIZ;

architecture Behavioral of MATRIZ is

signal cont_multiplex:	integer range 0 to 12000000; --Definirá la velocidad de multiplexación
signal column_enable:	std_logic_vector(7 downto 0); --Almacena la columna que se activará
signal data_column:	integer range 0 to 7; --Almacena los bits a mostrarse en cada columna

--Implementación de memoria.
Type memoria is array (0 to 7) of std_logic_vector(7 downto 0);

--Arreglo para el número 0
signal Numero_0: memoria:= ("00000000",
									 "00111100",
									 "01111110",
									 "01000010",
									 "01000010",
									 "01111110",
									 "00111100",
									 "00000000");
--Arreglo para el número 1									 
signal Numero_1: memoria:= ("00000000",
									 "00000000",
									 "01000100",
									 "01111110",
									 "01111110",
									 "01000000",
									 "00000000",
									 "00000000");
--Arreglo para el número 2
signal Numero_2: memoria:= ("00000000",
									 "01000100",
									 "01100110",
									 "01110110",
									 "01011110",
									 "01001110",
									 "01001100",
									 "00000000");
--Arreglo para el número 3									 
signal Numero_3: memoria:= ("00000000",
									 "01000010",
									 "01011010",
									 "01011010",
									 "01011010",
									 "01111110",
									 "00101100",
									 "00000000");
--Arreglo para el número 4									 
signal Numero_4: memoria:= ("00000000",
									 "00011000",
									 "00011100",
									 "01010110",
									 "01110110",
									 "01111110",
									 "01000000",
									 "00000000");
--Arreglo para el número 5
signal Numero_5: memoria:= ("00000000",
									 "01011110",
									 "01011110",
									 "01011010",
									 "01011010",
									 "01111010",
									 "00110010",
									 "00000000");
--Arreglo para el número 6									 
signal Numero_6: memoria:= ("00000000",
									 "00111100",
									 "01111110",
									 "01001010",
									 "01001010",
									 "01111010",
									 "00110000",
									 "00000000");
--Arreglo para el número 7									 
signal Numero_7: memoria:= ("00000000",
									 "00000110",
									 "01000110",
									 "01100010",
									 "01110010",
									 "00011110",
									 "00001110",
									 "00000000");
--Arreglo para el número 8
signal Numero_8: memoria:= ("00000000",
									 "00110100",
									 "01111110",
									 "01011010",
									 "01011010",
									 "01111110",
									 "00110100",
									 "00000000");
--Arreglo para el número 9
signal Numero_9: memoria:= ("00000000",
									 "00001100",
									 "01011110",
									 "01010010",
									 "01110010",
									 "01111110",
									 "00111100",
									 "00000000");
begin

	Enable <= column_enable; --Se muestra la columna correspondiente
	
	process(clk)
		begin
		
      if(rising_edge(Clk)) then
			if(cont_multiplex = 12000) then
				cont_multiplex <= 0;
				if(column_enable = "00000001") then
					column_enable <= "00000010"; --Se activa columna 1
					data_column <= 1; --Se muestran los bits de columna 1
				elsif(column_enable = "00000010") then
					column_enable <= "00000100"; --Se activa columna 2
					data_column <= 2; --Se muestran los bits de columna 2
				elsif(column_enable = "00000100") then
					column_enable <= "00001000"; --Se activa columna 3
					data_column <= 3; --Se muestran los bits de columna 3
			   elsif(column_enable = "00001000") then
					column_enable <= "00010000"; --Se activa columna 4
					data_column <= 4; --Se muestran los bits de columna 4
				elsif(column_enable = "00010000") then
					column_enable <= "00100000"; --Se activa columna 5
					data_column <= 5; --Se muestran los bits de columna 5
				elsif(column_enable = "00100000") then
					column_enable <= "01000000"; --Se activa columna 6
					data_column <= 6; --Se muestran los bits de columna 6
				elsif(column_enable = "01000000") then
					column_enable <= "10000000"; --Se activa columna 7
					data_column <= 7; --Se muestran los bits de columna 7
				else
					column_enable <= "00000001"; --Se activa columna 0
					data_column <= 0; --Se muestran los bits de columna 0
				end if;
			 else
				cont_multiplex <= cont_multiplex + 1;
			 end if;	 
      end if;
		
		case (Dato) is 
			when "00110000" => Column <= Numero_0(data_column); --Se muestra Matriz del numero 0
			when "00110001" => Column <= Numero_1(data_column); --Se muestra Matriz del numero 1
			when "00110010" => Column <= Numero_2(data_column); --Se muestra Matriz del numero 2
			when "00110011" => Column <= Numero_3(data_column); --Se muestra Matriz del numero 3
			when "00110100" => Column <= Numero_4(data_column); --Se muestra Matriz del numero 4
			when "00110101" => Column <= Numero_5(data_column); --Se muestra Matriz del numero 5
			when "00110110" => Column <= Numero_6(data_column); --Se muestra Matriz del numero 6
			when "00110111" => Column <= Numero_7(data_column); --Se muestra Matriz del numero 7
			when "00111000" => Column <= Numero_8(data_column); --Se muestra Matriz del numero 8
			when "00111001" => Column <= Numero_9(data_column); --Se muestra Matriz del numero 9
			when others => Column <= "00011000";
		end case;
		
	end process;

end Behavioral;