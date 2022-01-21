// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;
pragma experimental ABIEncoderV2;

contract OMS_COVID {

    //Dirección de la OMS -> Owner / Dueño del contrato
    address public OMS;

    //Contructor del contrato
    constructor() public {
        OMS = msg.sender;
    }

    //Mapping para relacionar los centros de salud (address) con la validez del sistema de gestión
    mapping(address => bool) public Validacion_CentrosSalud;

    // Relacionar una direccion de un Hospital de un centro de salud con su contrato
    mapping (address => address) public CentroSalud_Contrato;

    // Array de direcciones que almacene los centros de salud validados
    address[] public direcciones_contratos_salud;

    // Array de solicitudes de acceso
    address[] solicitudes_acceso;

    // Eventos a emitir
    event NuevoCentroValidado(address);
    event NuevoContrato(address, address);
    event SolicitarAcceso(address);

    // Modificador que permita unicamente la ejecucion de funciones por la OMS
    modifier aprobarOMS (address _direccion) {
        require(_direccion == OMS, "No tienes permisos para realizar esta operacion");
        _;
    }

    // Funcion para solicitar acceso al sistema medico
    function solicitarAcceso() public {

        solicitudes_acceso.push(msg.sender);
        emit SolicitarAcceso(msg.sender);

    }

    //Funcion que permita visualizar las direcciones que han solicitado este acceso
    function visualizarSolicitudes() public view aprobarOMS(msg.sender) returns(address[] memory) {

        return solicitudes_acceso;
    }


    // Función para validar nuevos centros de salud que puedan autogestionarde -> Unicamente OMS
    function centrosSalud(address _centroSalud) public aprobarOMS(msg.sender) {
        
        // Asignación del estado de validez al centro de salud
        Validacion_CentrosSalud[_centroSalud] = true;

        // Emision del evento
        emit NuevoCentroValidado(_centroSalud);
    }

    // Funcion que permita crear un contrato inteligente
    function FactoryCentroSalud() public {
        // Filtrado para que unicamente los centros de salud validados sean capaces de ejecutar esta funcion
        require(Validacion_CentrosSalud[msg.sender] == true, "No tienes permisos para ejecutar esta funcion");
        
        // Generar un smart contract -> Generar su direccion
        address contrato_CentroSalud = address(new CentroSalud(msg.sender));

        // Almacenar la direccion del contrato en el Array
        direcciones_contratos_salud.push(contrato_CentroSalud);

        // Relacion ente el centro de salud y su contrato
        CentroSalud_Contrato[msg.sender] = contrato_CentroSalud;

        //Emit del evento
        emit NuevoContrato(contrato_CentroSalud, msg.sender);

    }

    
    

}

// Contrato Autogestionable por el Centro de Salud
contract CentroSalud {

    address public DireccionContrato;
    address public DireccionCentroSalud;

    constructor (address _direccion) public {

        DireccionCentroSalud = _direccion;
        DireccionContrato = address(this);

    }

    // Mapping que relacione una ID con un resultado de un prueba de COVID
    // mapping(bytes32 => bool) ResultadoCOVID;

    // // Mapping para relacionar el hash de la prueba con el codigo IPFS
    // mapping(bytes32 => string) Resultado_IPFS;

    //Mappingh para relacionar el hash de la persona con los resultados (siagnostico, codigo IPFS)
    mapping(bytes32 => ResultadoCOVID) ResultadosCOVID;

    //Estructura de los resultados
    struct ResultadoCOVID {
        bool diagnostico;
        string CodigoIPFS;
    }

    //Eventos 
    event NuevoResultado(bool, string);

    //Filtrado de las funciones a ejecutar por el centro de salud
    modifier UnicamenteCentroSalud(address _direccion) {
        require(_direccion == DireccionCentroSalud, "No tienes permisos para ejecutar esta funcion");
        _;
    }

    //Funcion para emitir un resultado de la prueba de COVID
    //CID -> QmQhSPRu4E9Jgj1JsVn22rcZKff5vUdXbwMRfqNvSfgDzv
    function resultadosPruebaCovid(string memory _idPersona, bool _resultadoCOVID, string memory _codigoIPFS) public UnicamenteCentroSalud(msg.sender)  {
        // Hash de la identificación de la persona
        bytes32 hash_idPersona = keccak256(abi.encodePacked(_idPersona));

        // //Relacion entre el hash de la persona y el resultado de la prueba COVID
        // ResultadoCOVID[hash_idPersona] = _resultadoCOVID;
        // //Relacion con el codigo IPFS
        // Resultado_IPFS[hash_idPersona] = _codigoIPFS;

        //Relacion del hash de la persona con la estructura de resultados
        ResultadosCOVID[hash_idPersona] = ResultadoCOVID(_resultadoCOVID, _codigoIPFS);

        //Emitimos el evento
        emit NuevoResultado(_resultadoCOVID, _codigoIPFS);

    }

    //Funcion que permita la visualizacion de los resultados
    function verResultados(string memory _idPersona) public view returns(string memory, string memory) {

        //Hash de la identidad de la persona
        bytes32 hash_idPersona = keccak256(abi.encodePacked(_idPersona));

        // Retorno de un booleano como un string
        string memory resultadoPrueba;

        if(ResultadosCOVID[hash_idPersona].diagnostico == true) {
            resultadoPrueba = "Positivo";
        } else {
            resultadoPrueba = "Negativo";
        }

        //Retorno de parametros
        string memory ipfs = ResultadosCOVID[hash_idPersona].CodigoIPFS;
        return (resultadoPrueba, ipfs);
    }


}