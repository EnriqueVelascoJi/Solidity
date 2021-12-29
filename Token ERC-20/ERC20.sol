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

//Contract
contract ERC20Basic is IERC20 {

    event Transfer(address indexed _from, address indexed _to, uint256 _tokens);
    event Approval(address indexed _owner, address indexed _spender, uint256 _tokens);

    using SafeMath for uint256;

    function totalSupply() public override view returns(uint256) {
        return 0;
    }
    function balanceOf(address _account) public override view returns(uint256) {
        return 0;
    }
    function allowance(address _owner, address _spender) public override view returns(uint256) {
        return 0;
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