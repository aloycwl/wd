//SPDX-License-Identifier:None
pragma solidity 0.8.18;

import "./Proxy.sol";
import "./GameEngine.sol";
import "./ERC20.sol";
import "./DID.sol";
import "./Interfaces.sol";
import "./ERC721.sol";

//专注部署合约
contract Deployer {

    function deployAll(string calldata name, string calldata symbol) external returns (address proxy) {

        address did = deployDID();
        proxy = deployProxyPlus(did, name, symbol);

    }

    function deployProxyPlus(address did, string memory name, string memory symbol) public returns (address proxy) {

        proxy = deployProxy();
        address gameEngine = deployGameEngine(proxy);
        address erc20 = deployERC20(proxy, gameEngine, 1e27, name, symbol);
        address erc721 = deployERC721(proxy, name, symbol);

        IProxy iProxy = IProxy(proxy);
        iProxy.setAddr(gameEngine, 1);
        iProxy.setAddr(address(erc20), 2);
        iProxy.setAddr(did, 3);
        iProxy.setAddr(msg.sender, 4); //signer
        IUtil(did).setAccess(gameEngine, 900); //for withdrawal access
        IUtil(did).setAccess(erc20, 900); //for storage
        IUtil(did).setAccess(erc721, 900); //for storage

    }

    function deployProxy() public returns (address proxy) {

        proxy = address(new Proxy());
        IUtil(proxy).setAccess(msg.sender, 999);
        setDeployment(proxy, 0);

    }

    function deployGameEngine(address proxy) public returns (address gameEngine) {

        gameEngine = address(new GameEngine(proxy));
        IUtil(gameEngine).setAccess(msg.sender, 999);
        setDeployment(gameEngine, 1);

    }

    function deployERC20(address proxy, address receiver, uint amt, string memory name, string memory symbol) 
        public returns (address erc20) {

        erc20 = address(new ERC20(proxy, receiver, amt, name, symbol));
        IUtil(erc20).setAccess(msg.sender, 999);
        setDeployment(erc20, 2);

    }

    function deployDID() public returns (address did) {

        did = address(new DID());
        IUtil(did).setAccess(msg.sender, 999);
        setDeployment(did, 3);

    }

    function deployERC721(address proxy, string memory name, string memory symbol) 
        public returns (address erc721) {

        erc721 = address(new ERC721(proxy, name, symbol));
        IUtil(erc721).setAccess(msg.sender, 999);
        setDeployment(erc721, 2);

    }

    //设置和索取部署资料
    address[] private enumAddresses;
    uint[] private enumFunctions;

    function setDeployment(address addr, uint func) private {

        enumAddresses.push(addr);
        enumFunctions.push(func);

    }

    function getAllDeployments() external view returns (address[] memory addresses, uint[] memory functions) {

        unchecked{

            uint count = enumAddresses.length;
            (addresses, functions) = (new address[](count), new uint[](count));
            for (uint i=0; i<count; i++) (addresses[i], functions[i]) = (enumAddresses[i], enumFunctions[i]);

        }

    }
    
}
