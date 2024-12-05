LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY calculadora IS
PORT (
    val_in      : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);  -- Valor de entrada para A ou B
    op          : IN  STD_LOGIC;                     -- OP=0 para soma, OP=1 para subtração
    ler_a_ctrl  : IN  STD_LOGIC;                     -- Controle para leitura de A
    ler_b_ctrl  : IN  STD_LOGIC;                     -- Controle para leitura de B
    resultado   : OUT STD_LOGIC_VECTOR (7 DOWNTO 0); -- Resultado da operação
    luz_soma    : OUT STD_LOGIC;                     -- Acende se for soma
    luz_subt    : OUT STD_LOGIC                      -- Acende se for subtração
);
END calculadora;

ARCHITECTURE structural OF calculadora IS
    -- Declaração do componente somador_subtrator
    COMPONENT somador_subtrator 
    PORT (
        val_in        : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        op            : IN STD_LOGIC;
        carry_out     : OUT STD_LOGIC;
        resultado     : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        ler_a         : IN STD_LOGIC;
        ler_b         : IN STD_LOGIC;
        default_state : OUT STD_LOGIC;
        A_out         : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        B_out         : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
    END COMPONENT;

    SIGNAL carry_out_sig  : STD_LOGIC := '0';
    SIGNAL default_state_sig : STD_LOGIC := '0';
    SIGNAL a_out_sig      : STD_LOGIC_VECTOR (7 DOWNTO 0) := (others => '0');
    SIGNAL b_out_sig      : STD_LOGIC_VECTOR (7 DOWNTO 0) := (others => '0');

BEGIN

    

    -- Instância do componente somador_subtrator
    somador_inst : somador_subtrator
    PORT MAP (
        val_in        => val_in,
        op            => op,
        carry_out     => carry_out_sig,
        resultado     => resultado,
        ler_a         => ler_a_ctrl,
        ler_b         => ler_b_ctrl,
        default_state => default_state_sig,
        A_out         => a_out_sig,
        B_out         => b_out_sig
    );

    -- Controle das luzes
    luz_soma <= NOT op; -- Luz para soma
    luz_subt <= op;     -- Luz para subtração

END structural;
