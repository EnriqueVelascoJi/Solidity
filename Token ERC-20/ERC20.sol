// SPDX-License-Identifier: MIT
pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;

//Importamos la libreria de SafeMath
import "./SafeMath.sol";

//Interface de nuestro token ERC20
interface IERC20 {
    //Devuelve la cantidad de tokens en existencia
    function totalSupply() external view returns(uint256);

    //Devuelve la cantidad de tokens para una dirección indicada por parámetro
    function balanceOf(address _account) external view returns(uint256);

    //Devuelve el numero de tokens que el spender podrá gastar en nombre del propietario (owner)
    function allowance(address _owner, address _spender) external view returns(uint256);

    //Devuelve un valor boolean resultado de la operación indicada
    function transfer(address _recipient, uint256 _amount) external returns(bool);

    //Devuelve un valor booleano con el resultado de la operación de gasto
    function approve(address _spender, uint256 _amount) external returns(bool);

    //Devuelve un valor booleano con el resulltado de la opreción de paso de una cantidad de tokens usando el método allowance()
    function transferFrom(address _sender, address _recipient, uint256 _amount) external returns(bool);

    //Eventos
    //Evento que se debe emitir cuando una cantidad de tokens pase de un origen a un destino
    event Transfer(address indexed _from, address indexed _to, uint256);

    //Evento que se debe emitir cuando se establece una asignación con el método allowance
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

//Contrato
contract ERC20Basic is IERC20 {

    event Transer(address indexed _from, address indexed _to, uint256);
    event Approval(address indexed _owner, address indexed _spender, uint256 _tokens);

    using SafeMath for uint256;
}