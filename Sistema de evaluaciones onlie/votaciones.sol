//Indicamos la versión
// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0 <0.9.0;
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
        *Votar (Solo se es pposible votar una vez)
        *Ver los votos de un candidato
        *Ver los resultados de la votacion de manera general
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

    //Funcion que permite hacer una votacion (Solo se puede votar una vez)
    function Votar(string memory _candidato) public {

        //Creamos el hash del votante
        bytes32 hash_votante = keccak256(abi.encodePacked(msg.sender));

        //Verificamos que aún no se haya emitido un voto
        for(uint i=0; i<votantes.length; i++){
            require(votantes[i]!=hash_votante, "Ya has votado previamente");
        }

        //Si no ha votado se agrega al arreglo de votantes
        votantes.push(hash_votante);

        //Se le suma un voto al candidato selecioado
        votos_Candidato[_candidato] ++;

    }

    //Dado el nombre de un candidato nos devuelve el numero de votos que tiene
    function VerVotos(string memory _candidato) public view returns(uint) {
        
        //Regresamos el númeo de votos del candidato
        return votos_Candidato[_candidato];
    }

    //Funcion que realiza el parseo de un uint -> string
    function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len - 1;
        while (_i != 0) {
            bstr[k--] = byte(uint8(48 + _i % 10));
            _i /= 10;
        }
        return string(bstr);
    }

    //Ver los votos de cada uno de los candidatos
    function VerResultados() public view returns(string memory) {

        //Gurdamos en una variable string los candidatos con sus respectivos votos
        string memory resultados;

        for(uint i = 0; i < lista_Candidatos.length; i++) {
            /*Actualizamos el string de resultados y añadimos el candidato que ocupa
            la posición "i" y su número de votos
            */
            resultados = string(abi.encodePacked(resultados, "(", lista_Candidatos[i], ", ", uint2str(VerVotos(lista_Candidatos[i])), ")-------"));
        }

        //Devolvemos los resultados de las votaciones
        return resultados;
    }

    //Funcion que extrae el ganador de las votaciones
    function Ganador() public view returns(string memory) {
        
        //Declaramso la variable ganador para contener el nombre del candidato ganador
        string memory ganador = lista_Candidatos[0];

        //En caso de empate
        bool flag;

        //Algoritmo que elige al ganador de las votaciones
        for(uint i = 1; i < lista_Candidatos.length; i++) {
            if(votos_Candidato[ganador] < votos_Candidato[lista_Candidatos[i]]) {
                ganador = lista_Candidatos[i];
                flag = false;
            } else {
                if(votos_Candidato[ganador] == votos_Candidato[lista_Candidatos[i]]) {
                    flag = true;
                }
            }
        }
        
        //Devolvemos si hay un ganador
        if(flag) {
            ganador = "Hay un empate entre los candidatos";
        }
        return ganador;


    }







}