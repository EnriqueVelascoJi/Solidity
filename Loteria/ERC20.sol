// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 < 0.9.0;
pragma experimental ABIEncoderV2;
import './SafeMath.sol';

//Enrique Velasco --> 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
//Luis --> 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
//Maria --> 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db


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

    //Para loteria
    function transfernciaLoteria(address _emisor, address _recipient, uint256 _numTokens) external returns(bool);

    //Devuelve un valor boolano con el resultado de la operacion de gasto
    function approve(address _spender, uint256 _amount) external returns(bool);

    //Devuelve un valor booleano con el resultado de la operación de paso de una cantidad de tokens usando el método allowance()
    function transferFrom(address _sender,address _recipient, uint256 _amount) external returns(bool);

    //Eventos
    //Evento que se debe emitir cuando una cantidad de tokens pasa de un origen a un destin
    // event Transfer(address indexed _from, address indexed _to, uint256 _value);

    //Evento que se debe emitit cuando se establece una asignación con el método allowance
    // event Approval(address indexed _owner, address indexed _spender, uint256 _value);
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
    constructor (uint256 _initialSupply) public {
        totalSupply_ = _initialSupply;
        balances[msg.sender] = totalSupply_;
    }

    function totalSupply() public override view returns(uint256) {
        return totalSupply_;
    }
    function increaseTotalSupply(uint _newTokensAmount) public {
        totalSupply_ += _newTokensAmount;
        balances[msg.sender] += _newTokensAmount;
    }
    function balanceOf(address _tokenOwner) public override view returns(uint256) {
        return balances[_tokenOwner];
    }
    function allowance(address _owner, address _delegate) public override view returns(uint256) {
        return allowed[_owner][_delegate];
    }
    function transfer(address _recipient, uint256 _numTokens) public override returns(bool) {
        require(_numTokens <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender].sub(_numTokens);
        balances[_recipient] = balances[_recipient].add(_numTokens);

        //Notificamos la transferencia
        emit Transfer(msg.sender, _recipient, _numTokens);
        return true;
    }
    function transfernciaLoteria(address _emisor, address _recipient, uint256 _numTokens) public override returns(bool) {
        require(_numTokens <= balances[_emisor]);
        balances[_emisor] = balances[_emisor].sub(_numTokens);
        balances[_recipient] = balances[_recipient].add(_numTokens);

        //Notificamos la transferencia
        emit Transfer(msg.sender, _recipient, _numTokens);
        return true;
    }
    function approve(address _delegate, uint256 _numTokens) public override returns(bool) {
        require(_numTokens <= balances[msg.sender]);
        allowed[msg.sender][_delegate] = _numTokens;
        emit Approval(msg.sender, _delegate, _numTokens);
        return true;
    }
    function transferFrom(address _owner, address _buyer, uint256 _numTokens) public override returns(bool) {
        require(_numTokens <= balances[_owner]);
        require(_numTokens <= allowed[_owner][msg.sender]);

        //Retiramos el numTokens tanto del owner como del spender
        balances[_owner] = balances[_owner].sub(_numTokens);
        allowed[_owner][msg.sender] = allowed[_owner][msg.sender].sub(_numTokens);
        
        //Se los cedemos al buyer
        balances[_buyer] = balances[_buyer].add(_numTokens);

        emit Transfer(_owner, _buyer, _numTokens);
        return true;
    }

}