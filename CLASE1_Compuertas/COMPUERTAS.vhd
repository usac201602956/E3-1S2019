----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:33:30 03/12/2019 
-- Design Name: 
-- Module Name:    COMPUERTAS - Behavioral 
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

entity COMPUERTAS is
	port(
		--Forma de declarar entradas y salidas, del tipo logicas.
		a,b:		in		std_logic;
		c:			out	std_logic;
		
		--Forma de declarar entradas y salidas, del tipo vector logico.
		Salidas:		out	std_logic_vector(1 downto 0);
		entradas:	in		std_logic_vector(1 downto 0)
	);
	
end COMPUERTAS;

architecture Behavioral of COMPUERTAS is

--Dentro de la arquitectura se deben declarar las señales.
signal temp:	std_logic;

begin
	--Primer forma de operar entradas y salidas, de tipo logicas.
	c <= not(a xor b);
	
	--Las señales pueden ser modificadas para posteriormente utilizarlas.
	temp <= entradas(0) or entradas(1);
	
	--Segunda forma de operar entradas y salidas, de tipo vector.
	Salidas(0) <= not(temp);
	Salidas(1) <= entradas(0) xor temp;

end Behavioral;

