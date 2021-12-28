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
}  

//Contract
contract ERC20Basic is IERC20 {

    //Devulve la cantidad de tokens en existencia
    function totalSupply() public override view returns(uint256) {
        return 0;
    }

    //Devuelve la cantidad de tokens para una direccion indicada por parametro
    function balanceOf(address _account) public override view returns(uint256) {
        return 0;
    }

    //Devuelve el numero de tokens que el spender podrá gastar en nombre del propietario (owner)
    function allowance(address _owner, address _spender) public override view returns(uint256) {
        return 0;
    }

    //Devuelve un valor booleano resultado de la operación indicada
    function transfer(address _recipient, uint256 _amount) public override returns(bool) {
        return false;
    }

    //Devuelve un valor boolano con el resultado de la operacion de gasto
    function approve(address _spender, uint256 _amount) public override returns(bool) {
        return false;
    }

    //Devuelve un valor booleano con el resultado de la operación de paso de una cantidad de tokens usando el método allowance()
    function transferFrom(address _sender,address _recipient, uint256 _amount) public override returns(bool) {
        return false;
    }

}