//Indicamos la versiòn del còdigo
// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;
pragma experimental ABIEncoderV2;

//  ---------------------------------
//    ALUMNO   /   ID    /   NOTA
//  ---------------------------------
//    Marcos  /  77755N  /    5
//    Joan    /  12345X  /    9
//    Maria   /  02468T  /    2
//    Marta   /  13579U  /    3
//    Alba    /  98765Z  /    5

//nicialiamos el contrato
contract notas {
    
    //Direccion del profesor
    address public profesor;
    
    //Constructor 
    constructor () public {
        profesor = msg.sender; //Direccion de la persona que despliega el contrato sobre la caadena de bloques
        
    }
    
    //Mappig para relacionar el Hash de la identidad del alumno con su nota del examen
    mapping(bytes32 => uint) Notas;
    
    //Array de los alumnos que pidan revisiones del examen
    string[] revisiones;
    
    //Eventos
    event alumno_evaluado(bytes32);
    event evento_revision(string);
    
    
    //Función para evaluar a alumnos
    function Evaluar(string memory _idAlumno, uint _nota) public UnicamenteProfesor(msg.sender) {
        
        //Hash de la identificación del alumno
        bytes32 hash_idAlumno = keccak256(abi.encodePacked(_idAlumno));
        
        //Relacion entre el has de la identificacion del alumno y su Nota
        Notas[hash_idAlumno] = _nota;
        
        //Emision del evento_revision
        emit alumno_evaluado(hash_idAlumno);
    }
    
    //Control de las funciones jecutables por el profesor
    modifier UnicamenteProfesor(address _direccion) {
        
        //Requiere que la dirección introducida por parametro sea igual al owner del contrato
        require(_direccion == profesor, "No tienes permisos para ejecutar esta funcion");
        _;
    }
    
    //alumnos
    // Funcion para ver las notas de un alumno
    function VerNotas(string memory _idAlumno) public view returns(uint){
        
        //Hash de la identificación del alumno
        bytes32 hash_idAlumno = keccak256(abi.encodePacked(_idAlumno));
        
        //Nota asociadaa al hash del alumno 
        uint nota_alumno = Notas[hash_idAlumno];
        
        //Visualizar la Nota 
        return nota_alumno;
    }
    
    //Funcion para pedir una revision del examen
    function Revision(string memory _idAlumno) public {
        
        //Alacenamiento de la identidad del alumno en un array
        revisiones.push(_idAlumno);
        
        //Emsión del evento revision
        emit evento_revision(_idAlumno);
    }
    
    // Función para ver los alumnos que han solicitado revision de examen
    function VerRevisiones() public view UnicamenteProfesor(msg.sender) returns(string [] memory){
        
        //Devolver las identidades de los alumnos
        return revisiones;
    }
}