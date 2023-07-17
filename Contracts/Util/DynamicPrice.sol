//SPDX-License-Identifier: None
//solhint-disable-next-line compiler-version
pragma solidity ^0.8.18;
pragma abicoder v1;

import {DID, ERC20, Access} from "Contracts/ERC20.sol";

contract DynamicPrice {

    constructor(address did) {

        assembly {
            sstore(0x0, did)
            sstore(0x1, origin())
        }
    }

    function owner() public view returns (address a) {
        assembly {
            a := sload(0x1)
        }
    }

    function pay(address contAddr, uint _list, address to, uint fee) external {
        unchecked {
            assembly {
                // (address tokenAddr, uint price) = iDID.listData(address(this), contAddr, _list)
                let ptr := mload(0x40)
                mstore(ptr, 0xdf0188db00000000000000000000000000000000000000000000000000000000)
                mstore(add(ptr, 0x04), contAddr)
                mstore(add(ptr, 0x24), contAddr)
                mstore(add(ptr, 0x44), _list)
                pop(staticcall(gas(), sload(0x0), ptr, 0x64, 0x0, 0x40))
                let tokenAddr := mload(0x0)
                let price := mload(0x20)
                
                if gt(price, 0) {
                    fee := div(mul(price, sub(0x2710, fee)), 0x2710)

                    // 如果不指定地址，则转入主币，否则从合约地址转入
                    if iszero(tokenAddr) { // if(tokenAddr == address(0))
                        if lt(price, callvalue()) { // require(msg.value >= price, "04")
                            mstore(0x80, shl(229, 4594637)) 
                            mstore(0x84, 0x20) 
                            mstore(0xA4, 0x2)
                            mstore(0xC4, "04")
                            revert(0x80, 0x64)
                        }
                        // payable(to).transfer(price)
                        pop(call(gas(), to, fee, 0x0, 0x0, 0x0, 0x0))
                        // payable(this.owner()).transfer(address(this).balance)
                        pop(call(gas(), sload(0x1), selfbalance(), 0x0, 0x0, 0x0, 0x0))
                    }

                    if gt(tokenAddr, 0) {
                        ptr := mload(0x40)
                        mstore(ptr, 0x23b872dd00000000000000000000000000000000000000000000000000000000)
                        mstore(add(ptr, 0x04), origin())
                        mstore(add(ptr, 0x24), address())
                        mstore(add(ptr, 0x44), price)

                        // require(iERC20.transferFrom(msg.sender, address(this), price), "05")
                        if iszero(call(gas(), tokenAddr, 0x0, ptr, 0x64, 0x0, 0x0)) {
                            mstore(0x80, shl(229, 4594637)) 
                            mstore(0x84, 0x20) 
                            mstore(0xA4, 0x2)
                            mstore(0xC4, "05")
                            revert(0x80, 0x64)
                        }

                        // iERC20.transferFrom(address(this), to, price)
                        mstore(add(ptr, 0x04), address())
                        mstore(add(ptr, 0x24), to)
                        mstore(add(ptr, 0x44), fee)
                        pop(call(gas(), tokenAddr, 0x0, ptr, 0x64, 0x0, 0x0))
                        
                        // iERC20.transferFrom(address(this), this.owner(), price - deducted)
                        mstore(add(ptr, 0x24), sload(0x1))
                        mstore(add(ptr, 0x44), sub(price, fee))
                        pop(call(gas(), tokenAddr, 0x0, ptr, 0x64, 0x0, 0x0))
                    }
                }
            }
        }
    }
}