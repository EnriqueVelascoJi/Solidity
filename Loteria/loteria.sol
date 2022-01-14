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
    event tokens_devueltos(uint, address);

    //Funcion para comprar boletos de loteria
    function comprarBoleto(uint _boletos) public {
        //Precio total de los boletos a comprar
        uint precio_total = _boletos*PrecioBoleto;
        //Filtrado de los tokens a pagar
        require(precio_total <= MisTokens(), "Necesitas comprar mas tokens");

        //Transferencia de tokens al owner -> bote/premio
        token.transfernciaLoteria(msg.sender, owner, precio_total);

        /* 
        randNonce (numero que solo se utiliza una vez para evitar la multiplicidad de elementos)
        *Lo convertimos a uint y le sacamos el modulo % 10000 para tomar los ultimos 4 digitos (dando un valor de entre 0-9)
        */
        for(uint i = 0; i < _boletos; i++) {
            uint random = uint(keccak256(abi.encodePacked(now, msg.sender, randNonce))) % 10000;
            randNonce ++;

            //Almacenamos todos los datos
            idPersona_boletos[msg.sender].push(random);
            boletos_comprados.push(random);

            //Asignamos el ADN del boleto a la persona
            ADN_boleto[random] = msg.sender;

            //Evento
            emit boletos_comprados(random, msg.sender);

        }

    }

    //Visualizar el numero de boletos de una persona
    function tusBoletos() public view returns(uint[] memory) {
        return idPersona_boletos[msg.sender];
    }

    //Funcion para generar el ganador
    function generarGanador() public Unicamente(msg.sender) {
        //Debe haber boletos comprados
        require(boletos_comprados.length > 0, "No hay boletos comprados");

        //Declaración de la longitud del array
        uint longitud = boletos_comprados.length;

        //Aleatoriamente elijo un numero entre 0 y la longitud
        uint posicion_array = uint(uint(keccak256(abi.encodePacked(now))) % longitud);
        uint eleccion = boletos_comprados[posicion_array];

        //Emision del evento ganador
        emit boleto_ganador(eleccion);

        //Recuperar la direccion del gaandor
        address ganador = ADN_boleto[eleccion];

        //Le enviamos tokens del premio al ganador
        token.transfernciaLoteria(owner, ganador, Bote());
        
    }
    
    //Funcion que hace regresar los tokens por ether
    function devolverETH(uint _numTokens) public payable{

        //Verificamos que el numero de tokens sea positivo
        require(_numTokens > 0, "No puedes devolver cantidades negativas");
        //Verificar que se tengan los tokens a devolver
        require(_numTokens <= misTokens(), "No puedes devolver esa cantidad de tokens");
        
        //Calcular el monto de ETH que se necesitan devolver
        uint ETH = precioTokens(_numTokens);

        //Quitamos los tokens del balance del solicitante
        token.transfernciaLoteria(msg.sender, contrato, _numTokens);

        //Transferimos el monto de ETH
        payable(msg.sender).transfer(ETH);

        //Emitimos el evento
        emit tokens_devueltos(_numTokens, msg.sender);


    }
}