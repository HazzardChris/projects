// SPDX-License-Identifier: UNLICENSED
// Example smart contract using truffle
//truffle deploy
//truffle console to interact with the contract
/*
    let instance = await Scorecard.deployed()
    let accounts = await web3.eth.getAccounts()
    instance.addStudentDetails("Green","Smith",{from:accounts[1]})
*/
pragma solidity >=0.4.0 <0.9.0;

contract Scorecard {
    address public classTeacher;
    uint256 studentCount = 0;

    constructor() public {
        classTeacher = msg.sender;
    }

    modifier onlyClassTeacher(address _classTeacher) {
        require(
            classTeacher == _classTeacher,
            "Only the class teacher has access to this function"
        );
        _;
    }

    struct StudentDetails {
        string studentFirstName;
        string studentLastName;
        uint256 id;
    }

    struct Score {
        uint256 studentId;
        uint256 englishMarks;
        uint256 mathsMarks;
        uint256 scienceMarks;
    }

    mapping(uint256 => StudentDetails) students;
    mapping(uint256 => Score) scores;

    event studentAdded(
        string _studentFirstName,
        string _studentLastName,
        uint256 _studentId
    );
    event studentScoreRecorder(
        uint256 _studentId,
        uint256 _englishMarks,
        uint256 _mathsMarks,
        uint256 _scienceMarks
    );

    function addStudentDetails(
        string memory _studentFirstName,
        string memory _studentLastName
    ) public onlyClassTeacher(msg.sender) {
        StudentDetails storage studentObj = students[studentCount];
        studentObj.studentFirstName = _studentFirstName;
        studentObj.studentLastName = _studentLastName;
        studentObj.id = studentCount;
        emit studentAdded(_studentLastName, _studentLastName, studentCount);
        studentCount++;
    }

    function addStudentScores(
        uint256 _studentId,
        uint256 _englishMarks,
        uint256 _mathsMarks,
        uint256 _scienceMarks
    ) public onlyClassTeacher(msg.sender) {
        Score storage scoreObject = scores[_studentId];
        scoreObject.englishMarks = _englishMarks;
        scoreObject.mathsMarks = _mathsMarks;
        scoreObject.scienceMarks = _scienceMarks;
        scoreObject.studentId = _studentId;
        emit studentScoreRecorder(
            _studentId,
            _englishMarks,
            _mathsMarks,
            _scienceMarks
        );
    }
}
