//Indicamos la versión
//License-Identifier: MIT

pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

//  ---------------------------------
//    CANTIDAD   /   EDAD    /   ID
//  ---------------------------------
//    Toni     /    20  /    12345X
//    Alberto  /    23  /    54321T
//    Joan     /    21  /    98765P
//    Javier   /    19  /    56789W

//Declaramos el contrato
contract Votacion {

    //DIRECCION DEL PROPIETARIO DEL CONTRATO (la persona que despliega el contrato puede ser un ente gubernamental)
    address public owner;

    //Constructor
    constructor () public {
        owner = msg.sender;
    }

    //Candidatos
    //Relación entre el nombre del candidato y el Hash de sus datos personales
    mapping(string => bytes32) ID_Candidato;

    //Relación entre el nombre del candidato y el número de votos
    mapping(string => uint) votos_Candidato;

    //Lista para almaenar los nombre de los candidatos
    string[] lista_Candidatos;

    //Votantes
    //Lista de los hashes de la identidad de los votantes (el votante solo puede votar una sola vez)
    bytes32[] votantes;

    
    /*
    Funcionalidades:
        *Darse de alta como candidato en las votaciones
        *Ver a los posibles candidatos a votar
    */
    //Cualquier persona pueda usar esta funcion prara darse de alta en las eleciones
    function Representar(string memory _nombrePersona, uint _edadPersona, string memory _idPersona) public{

        //Hash de los datos del canidato
        bytes32 hash_Candidato = keccak256(abi.encodePacked(_nombrePersona, _edadPersona, _idPersona));


        //Almacenar el hash de los datos del candidato ligados a su nombre
        ID_Candidato[_nombrePersona] = hash_Candidato;

        //Almacenamos el nombre del candidato
        lista_Candidatos.push(_nombrePersona);

    }
    //Ver a los posibles candidatos para ser votados
    function VerCandidatos() public view returns(string[] memory) {
        //Regresamos la lista de candidatos
        return lista_Candidatos;
    }







}