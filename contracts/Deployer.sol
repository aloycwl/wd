//SPDX-License-Identifier:None
pragma solidity 0.8.18;

import "./Proxy.sol";
import "./GameEngine.sol";
import "./ERC20.sol";
import "./ERC721.sol";
import "./DID.sol";

contract DeployerStorage {

    mapping(string => address) public contracts;
    string[] private enumName;
    address[] private enumContracts;

    function setContract(string calldata name, address contractAddress) external {

        enumName.push(name);
        enumContracts.push(contractAddress);
        contracts[name] = contractAddress;

    }

    function showContracts() external view returns (string[] memory, address[] memory) {

        return (enumName, enumContracts);
        
    }

}


//专注部署合约
contract Deployer {

    function deployProxyPlus(address did, string memory name, string memory symbol) public returns (address proxy) {

        proxy = deployProxy();
        (address gameEngine, address erc20/*, address erc721*/) = (deployGameEngine(proxy), 
            deployERC20(proxy, string(abi.encodePacked(name," Token")), string(abi.encodePacked(symbol, "T")))/*,
            deployERC721(proxy, name, symbol)*/);

        Proxy iProxy = Proxy(proxy);
        iProxy.setAddr(proxy,               0);
        iProxy.setAddr(gameEngine,          1);
        iProxy.setAddr(erc20,               2);
        iProxy.setAddr(did,                 3);
        iProxy.setAddr(msg.sender,          4);         //签名人
        //iProxy.setAddr(erc721,              5);
        
        Access iAccess = Access(did);
        iAccess.setAccess(gameEngine,       900);       //需要授权来提币
        iAccess.setAccess(erc20,            900);       //用于储存
        //iAccess.setAccess(erc721,           900);       //用于储存

        ERC20(erc20).mint(gameEngine,       1e27);      //铸币
        setDeployment(msg.sender,           "[4 - Signer]");

    }

    function deployProxy() public returns (address addr) {

        addr = address(new Proxy());
        Access(addr).setAccess(msg.sender,    999);
        setDeployment(addr, "               [0 - Proxy]");

    }

    function deployGameEngine(address proxy) public returns (address addr) {

        addr = address(new GameEngine(proxy));
        Access(addr).setAccess(msg.sender,    999);
        setDeployment(addr,                 "[1 - Game Engine]");

    }

    function deployERC20(address proxy, string memory name, string memory symbol) 
        public returns (address addr) {

        addr = address(new ERC20(proxy, name, symbol));
        Access(addr).setAccess(msg.sender,    999);
        setDeployment(addr,                 "[2 - ERC20]");

    }

    /*function deployERC721(address proxy, string memory name, string memory symbol) 
        public returns (address addr) {

        addr = address(new ERC721(proxy, name, symbol));
        Access(addr).setAccess(msg.sender,   999);
        setDeployment(addr,                 "[5 - ERC721]");
        return addr;

    }*/

    //设置和索取部署资料
    address[] private enumAddresses;
    string[]  private enumFunctions;

    function setDeployment(address addr, string memory func) private {

        enumAddresses.push(addr);
        enumFunctions.push(func);

    }

    function getAllDeployments() external view returns (address[] memory addresses, string[] memory functions) {

        unchecked{

            uint count = enumAddresses.length;
            (addresses, functions) = (new address[](count), new string[](count));
            for (uint i; i < count; ++i) (addresses[i], functions[i]) = (enumAddresses[i], enumFunctions[i]);

        }

    }
    
}
