library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library my_lib;

package my_types is
    TYPE std_logic_matrix IS ARRAY(3 downto 0) OF std_logic_vector(0 to 6);
end package my_types;
