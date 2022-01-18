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
}