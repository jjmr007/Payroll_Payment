// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;


import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/SafeMath.sol";

abstract contract Token {
    
    function transferFrom(address _from, address _to, uint256 _value) public virtual returns (bool success);
    function transfer(address _to, uint256 _value) public virtual returns (bool success);
    function balanceOf(address _owner) public view virtual returns (uint256 balance);

}

contract Payroll {
    
    using SafeMath for uint;
    address public paYer;
    address payable[] public eMployees;
    address payable public Boss;
    bool public Flag;
    bool public Penalty;
    uint internal referencE;
    mapping (uint => string) internal wEek;
    uint constant internal Xtn = 86400;
    uint public Total_Balance;
    Token public _Token;

    constructor (address _token) public payable {
        eMployees = [0x14723A09ACff6D2A60DcdF7aA4AFf308FDDC160C, 0x4B0897b0513fdC7C541B6d9D7E929C4e5364D2dB, 0x583031D1113aD414F02576BD6afaBfb302140225, 0xdD870fA1b7C4700F2BD7f44238821C26f7392148];
        Boss = msg.sender;
        Flag = true;
        Penalty = false;
        referencE = now;
        wEek[0] = "Monday";
        wEek[1] = "Tuesday";
        wEek[2] = "Wendsday";
        wEek[3] = "Thursday";
        wEek[4] = "Friday";
        wEek[5] = "Saturday";
        wEek[6] = "Sunday";
        _Token = Token(_token);

    }

    modifier OnlypaYer() {
        
        require (
            
            msg.sender == paYer,
            "Sender not authorized."
            
            );
        _;

    }
    
    function Payment (uint256 _aMount) OnlypaYer public {
        
        _Token.transferFrom(paYer, address(this), _aMount);
        Total_Balance = Total_Balance.add(_aMount);
        
    }

    function TodayIs() public view returns (string memory) {
        uint _x = ((now.sub(referencE)).div(Xtn)).mod(7);
        return wEek[_x];
    }

    
    function bElongs(address _x) internal view returns (bool) {
        bool AnEnployee = false;
        for(uint i = 0; i < eMployees.length; i++) {
            if (eMployees[i] == _x) {
                AnEnployee = true;
            }
        }
        return AnEnployee;
    }
    
    function Pay() public {
        
        uint A = ((now.sub(referencE)).div(Xtn)).mod(7);
        require (A < 2);
        uint B;

        if (Penalty) {
            B = 35;
        } else {
            B = 40;
        }
        uint C = Total_Balance;
        if (A == 0) {
            require(msg.sender == Boss && !Flag);
            uint k = B.mul(C).div(100);
            _Token.transfer(Boss, k);
            Total_Balance = Total_Balance.sub(k);
            C = C.sub(k);
            k = C.div(eMployees.length);
            for (uint i=0; i < eMployees.length; i++) {
                _Token.transfer(eMployees[i], k);
            Total_Balance = Total_Balance.sub(k);
            }
            Flag = true;
            Penalty = false;
        } else if (A == 1) {
            require(bElongs(msg.sender) && !Flag);
            uint k = (B.sub(5)).mul(C).div(100);
            _Token.transfer(Boss, k);
            Total_Balance = Total_Balance.sub(k);
            uint h = (2*C).div(100);
            _Token.transfer(msg.sender, h);
            Total_Balance = Total_Balance.sub(h);
            C = C.sub(k.add(h));
            k = C.div(eMployees.length);
            for (uint j=0; j < eMployees.length; j++) {
                _Token.transfer(eMployees[j], k);
            Total_Balance = Total_Balance.sub(k);
            }
            Flag = true;
            Penalty = false;
        }
    }
    
    function FlagDown() public {
        uint A = ((now.sub(referencE)).div(Xtn)).mod(7);
        require (A >= 2 && A <= 6);
        uint C = Total_Balance;
        if (A > 1 && A <= 5) {
            require(msg.sender == Boss && Flag);
            Flag = false;
            Penalty =  false;
        } else if (A == 6) {
            require(bElongs(msg.sender) && Flag);
            uint k = (2*C).div(100);
            _Token.transfer(msg.sender, k);
            Total_Balance = Total_Balance.sub(k);
            Flag = false;
            Penalty = true;
        }
    }
    
    function Fired(address _Out) public {
        require(msg.sender == Boss && bElongs(_Out));
        for (uint i = 0; i < eMployees.length; i++) {
            if (eMployees[i] == _Out && i < eMployees.length-1) {
                for (uint j = i; j < eMployees.length-1; j++) {
                    eMployees[j] = eMployees[j+1];
                } 
                delete eMployees[eMployees.length-1];

            } else if (eMployees[i] == _Out && i == eMployees.length-1) {
                delete eMployees[eMployees.length-1];

                } 
        } 
    }
    
    function Hire(address payable _New) public {
        require(msg.sender == Boss && !bElongs(_New));
            eMployees.push();
            eMployees[eMployees.length-1] = _New;
    }
    
    function PaySuppliers(address payable _Supplier, uint _aMount) public {
        require(msg.sender == Boss && _aMount < _Token.balanceOf(address(this)));
        _Token.transfer(_Supplier, _aMount);
        Total_Balance -= _aMount;

    }
    
}