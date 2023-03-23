pragma solidity 0.8.19;//SPDX-License-Identifier:None

interface IERC20{
    function transfer(address,uint)external returns(bool);
}

interface GE{
    function score(address)external view returns(uint);
    function setScore(address, uint, string memory)external;
    function withdrawal(address, uint, string memory)external;
}

contract GameEngineProxy is GE{
    GE public m;
    address private _owner;
    constructor(address a, bytes32 b){
        _owner = msg.sender;
        m = GE(address(new GameEngine(a, b, msg.sender)));
    }
    function score(address a)external view returns(uint){ return m.score(a); }
    function setScore(address a, uint b, string memory c)external{ m.setScore(a, b, c); }
    function withdrawal(address a, uint b, string memory c)external{ m.withdrawal(a, b, c); }
    
    function NewAddress(address a)external{
        require(msg.sender == _owner);
        m = GE(a);
    }
}

contract GameEngine is GE{
    IERC20 erc20;
    bytes32 private key;
    mapping(address=>uint)public score;
    mapping(address => bool)public _access;
    modifier OnlyAccess(){
        require(_access[msg.sender]); _;
    }
    constructor(address a, bytes32 b, address c){
        (_access[c], erc20, key) = (true, IERC20(a), b);
    }
    //Basic function 基本功能
    function check(string memory a)private view{
        require(keccak256(abi.encodePacked(a))==key);
    }
    function setScore(address a, uint b, string memory c)external{
        check(c);
        score[a]+=b;
    }
    function withdrawal(address a, uint b, string memory c)external{
        check(c);
        erc20.transfer(a,b);
    }
    //Admin functions 管理功能
    function UpdateTokenAddress(address a)external OnlyAccess{
        erc20 = IERC20(a);
    }
    function UpdateKey(bytes32 a)external OnlyAccess{
        key = a;
    }
    function SetAccess(address a, bool b)external OnlyAccess{
        _access[a] = b;
    }
}