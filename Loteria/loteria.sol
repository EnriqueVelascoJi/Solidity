// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;
pragma experimental ABIEncoderV2;
import './ERC20.sol';

contract loteria {

    //Intancia del contrato token
    ERC20Basic private token;

    //Direcciones
    address public owner;
    address public contrato;

    //Numero de tokens a crear
    uint public tokens_creados = 10000;

    //Evento de compra de tokens
    event ComprandoTokens(uint, address);

    //Constructor
    constructor () public {
        token = new ERC20Basic(tokens_creados);
        owner = msg.sender;
        contrato = address(this);
    }

    //----------------------------- TOKEN ---------------------------
    //Establecer el precio de lo tokens en ETH
    function precioTokens(uint _numTokens) internal pure returns(uint) {
        return _numTokens * (1 ether);
    }

    //Funcion que permita crear mas toekens
    function generaTokens(uint _numTokens) public Unicamente(msg.sender) {
        token.increaseTotalSupply(_numTokens);
    }

    //modificador para hacer funciones solamente por el owner del contrato
    modifier Unicamente(address _direccion) {
        require(_direccion == owner, "No tienes permisos para ejecutar esta funcion");
        _;
    }

    //Funcion que permite comprar tokens para la adquisicion de tickets
    function comprarToken(uint _numTokens) public payable {
        
        uint coste = precioTokens(_numTokens);
        require(coste <= msg.value, "No tienes el dinero suficiente para comprar esos tokens");

        uint cambio = msg.value - coste;
        payable(msg.sender).transfer(cambio);

        //Obtener el valence de coste del contrato
        uint Balance = TokensDisponibles();
        require(_numTokens <= Balance, "Compra un numero de tokens adecuado");

        //Transferrir los tokens al comprador
        token.transfer(msg.sender, _numTokens);

        emit ComprandoTokens(_numToknes, msg.sender);
    }

    //Funcion que da a conocer el numero de tokens disponibles por el contrato
    function balanceTokens() public view returns(uint) {
        return token.balanceOf(contrato);
    }
    //Funcion que permite obtener el balance de tokens que estan en el Bote
    function verBote() public view returns(uint) {
        return token.balanceOf(owner);
    }

    //Balance de tokens de una persona
    function misTokens() public view returns(uint) {
        return token.balanceOf(msg.sender);
    }

    // --------------------- Loteria -----------------
    
    //Precio del boleto
    uint public PrecioBoleto = 5;
    //Relacion entre la persona y sus boletos
    mapping(address => uint[]) idPersona_boletos;
    //Relacion necesaria para identificar al ganador
    mapping(uint => address) ADN_boleto;
    //Numero aleatorio
    uint randNonce = 0;
    //Boletos generados
    uint[] boletos_comprados;

    //Eventos
    event boleto_comprado(uint, address);
    event boleto_ganador(uint);
}