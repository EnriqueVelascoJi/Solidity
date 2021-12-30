pragma solidity >=0.4.4 < 0.7.0;
pragma solidity ABIEncoderV2;
import './SafeMath.sol';

//Interface de nuestro token ERC-20
interface IERC20 {
    
    //Devulve la cantidad de tokens en existencia
    function totalSupply() external view returns(uint256);

    //Devuelve la cantidad de tokens para una direccion indicada por parametro
    function balanceOf(address _account) external view returns(uint256);

    //Devuelve el numero de tokens que el spender podrá gastar en nombre del propietario (owner)
    function allowance(address _owner, address _spender) external view returns(uint256);

    //Devuelve un valor booleano resultado de la operación indicada
    function transfer(address _recipient, uint256 _amount) external returns(bool);

    //Devuelve un valor boolano con el resultado de la operacion de gasto
    function approve(address _spender, uint256 _amount) external returns(bool);

    //Devuelve un valor booleano con el resultado de la operación de paso de una cantidad de tokens usando el método allowance()
    function transferFrom(address _sender,address _recipient, uint256 _amount) external returns(bool);

    //Eventos
    //Evento que se debe emitir cuando una cantidad de tokens pasa de un origen a un destin
    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    //Evento que se debe emitit cuando se establece una asignación con el método allowance
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}  

//Contrato
contract ERC20Basic is IERC20 {

    //Variables
    string public constant name = "KikeInu";
    string public constant symbol = "KiIn";
    uint8 public constant decimals = 18;



    event Transfer(address indexed _from, address indexed _to, uint256 _tokens);
    event Approval(address indexed _owner, address indexed _spender, uint256 _tokens);

    using SafeMath for uint256;

    //Mapping
    mapping (address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;
    uint256 totalSupply_;

    //Constructor
    constructor (uint256 initalSupply) public {
        totalSupply_ = initialSupply;
        balance[msg.sender] = totalSupply_;
    }

    function totalSupply() public override view returns(uint256) {
        return totalSupply_;
    }
    function increaseTotalSupply(uint _newTokensAmount) public {
        totalSupply_ += _newTokensAmount;
        balnces[msg.sender] += _newTokensAmount;
    }
    function balanceOf(address _tokenOwner) public override view returns(uint256) {
        return balances[_tokenOwner];
    }
    function allowance(address _owner, address _delegate) public override view returns(uint256) {
        return allowed[_owner][_delegate];
    }
    function transfer(address _recipient, uint256 _amount) public override returns(bool) {
        return false;
    }
    function approve(address _spender, uint256 _amount) public override returns(bool) {
        return false;
    }
    function transferFrom(address _sender,address _recipient, uint256 _amount) public override returns(bool) {
        return false;
    }

}