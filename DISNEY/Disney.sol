// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;
pragma experimental ABIEncoderV2;

//Imports others contracts
import "./ERC20.sol";

contract Disney {

    // ------------------- DECLARACIONES INICIALES -------------
    // Instancia del contato token
    ERC20Basic private token;

    //Dirección de Disney (owner)
    address payable public owner;

    //Constructor
    constructor () public {
        token = new ERC20Basic(10000);
        owner = payable(msg.sender);
    }

    //Estructura de datos para almacenar a los clientes de Disney
    struct cliente {
        uint tokens_comprados;
        string[] atracciones_disfrutadas;
    }

    // Mapping para el registro de clientes
    mapping (address => cliente) public Clientes;

    // ------------------- GESTION DE TOKENS -------------
    // Función para establecer el precio de un token
    function precioTokens(uint _numTokens) internal pure returns(uint) {
        //Conversion de tokens a ETH: 1 Token -> 1 ETH
        return _numTokens*(1 ether);
    }

    //Funcion para comprara tokens en Disney
    function comprarTokens(uint _numTokens) public payable {
        // Establercer el precio de os Tokens
        uint coste = precioTokens(_numTokens);

        //Se evalua el dinero que el cliente paga por lo tokens    
        require(msg.value >= coste, "Compra menos Tokens o paga con mas ethers");

        //Diferencia de lo que el cliente paga
        uint returnValue = msg.value - coste;

        //Disney retorna la cantidad de eth
        payable(msg.sender).transfer(returnValue);

        //Obtención del numero de tokens disponibles
        uint Balance = balanceOf();
        require(_numTokens <= Balance, "Compra un numero menor de tokens");
        // Se transfiere el numero de tokens al cliente
        token.transfer(msg.sender, _numTokens);

        //Registro de tokens comprados
        Clientes[msg.sender].tokens_comprados += _numTokens;

    }

    //Balance de tokens del contrato de disney
    function balanceOf() public view returns(uint) {
        return token.balanceOf(address(this));
    }

    //Visualizar el numero de tokens restantes de un cliente
    function misTokens() public view returns(uint) {
        return token.balanceOf(msg.sender);
    }

    //Funcion para generar mas tokens 
    function generaTokens(uint _numTokens) public Unicamente(msg.sender) {
        token.increaseTotalSupply(_numTokens);
    }

    //Modifier para controlar las funciones ejecutables por disney
    modifier Unicamente(address _direccion) {
        require(_direccion == owner, "No tiene permisos para ejecutar esa funcion");
        _;       
    }

    // ----------------------  Gestión de Disney ------------------------------
    
    //Eventos
    event disfruta_atraccion(string, uint, address);
    event nueva_atraccion(string, uint);
    event baja_atraccion(string);


    //Estructura de la atraccion
    struct atraccion {
        string nombre_atraccion;
        uint precio_atraccion;
        bool estado_atraccion;
    }

    // Mapping para relacionar un nombre de una tarccion con una estructura de datps de la atraccion
    mapping(string => atraccion) public MappingAtracciones;

    // Array para almecenar el nombre de las atracciones
    string [] Atracciones;

    //Mapping para relacionar una identidad (cliente) con su historial en DISNEY
    mapping(address => string []) HistorialAtracciones;

    //Star wars -> 2 Tokens
    //Toy Story -> 5 Tokens
    //Piratas del caribe -> 8 Tokens
    
    //Funcion que perite dar de alta una nueva atraccion
    function nuevaAtraccion(string memory _nombreAtraccion, uint _precio) public Unicamente(msg.sender) {
        //Creacion de una atraccion en Disney
        atraccion nuevaAtraccion = atraccion(_nombreAtraccion, _precio, true);
        MappingAtracciones[_nombreAtraccion] = nuevaAtraccion;

        //Almacenamos en un array el nombre de la atraccion
        Atracciones.push(_nombreAtraccion);
        
        //Emitir el evento de "Nueva atraccion"
        emit nueva_atraccion(_nombreAtraccion, _precio); 
    }

    //Funcion que da de baja una atraccion
    function bajaAtraccion(string memory _nombreAtraccion) public Unicamente(msg.sender) {
        
        //Solo cambiamos la proiedad de "estado_atraccion"
        MappingAtracciones[_nombreAtraccion].estado_atraccion = false;

        //Emitimos el evento
        emit baja_atraccion(_nombreAtraccion);
    }

    //Funcion que visualiza todas la atracciones que tiene Disney
    function verAtracciones() public wiew returns(string [] memory) {
        return Atracciones;
    }

    //Funcion para poder subirse a una atracción de Disney y pagar en tokens
    function subirseAtraccion(string memory _nombreAtraccion) public {
        //Precio de la atraccion en tokens
        uint tokens_atraccion = MappingAtracciones[_nombreAtraccion].precio_atraccion;

        //Verificar el estado de la atraccion (si esta disponible para su uso)
        require(MappingAtracciones[_nombreAtraccion].estado_atraccion == true, "La atraccion no esta disponible en estos momentos");

        //Verificar el numero de tokens que tiene el cliente para subirse a la atarccion
        require(tokens_atraccion <= misTokens(), "No tienes los suficientes tokens para subirte a la atraccion");

        /*
            El cliente paga la atraccion en Tokens:
            - Ha sido necesario crear una funcion en ERC20.sol con el nombre de: 'transferencia_disney'
            debido a que en caso de usar el TransferFrom las direcciones que se escogian 
            para realizar la transaccion eran equivocadas. Ya que el msg.sender que recibia el metodo
            TranferFrom era la direccion del contrato.
        */
        token.transferDisney(msg.sender, address(this), tokens_atraccion);

        //Almacenamiento en el historia de atracciones del cliente
        HistorialAtracciones[msg.sender].push(_nombreAtraccion);

        //Emisión del evento para disfrutar de la atraccion
        emit disfruta_atraccion(_nombreAtraccion, tokens_atraccion, msg.sender);

    }

    //Visualizar el historial de un cliente
    function verHistorialCliente() public view returns (string[] memory) {
        //Regresa el historial de un cliente
        return HistorialAtracciones[msg.sender];
    }

    //Funcion para que un cliente de Disney pueda devolver tokens
    function devolverTokens(uint _numTokens) public payable {

        //El numero de tokens a devolver es positivo
        require(_numTokens > 0, "Necesitas regresar una cantidad positiva de tokens");

        //El cliente debe tener el numero de tokens que desea devolver
        require(_numTokens <= misTokens(), "No tienes los tokens que deseas devolver");

        //El cliente devuelce los tokens
        token.transferDisney(msg.sender, address(this), _numTokens);

        //Devolucion de los ETH al cliente
        uint monto_a_devolver = precioTokens(_numTokens);
        payable(msg.sender).transfer(monto_a_devolver);

    }






}
