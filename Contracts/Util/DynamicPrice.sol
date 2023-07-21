// SPDX-License-Identifier: None
// solhint-disable-next-line compiler-version
pragma solidity ^0.8.18;
pragma abicoder v1;

contract DynamicPrice {

    constructor() {
        assembly {
            sstore(0xa, caller())
        }
    }

    function owner() external view returns (address a) {
        assembly {
            a := sload(0xa)
        }
    }

    function pay(address contAddr, uint _list, address to, uint fee) internal {
        assembly {
            // 索取List
            mstore(0x80, shl(0xe0, 0xdf0188db)) // listData(address,address,uint256)
            mstore(0x84, address())
            mstore(0xa4, contAddr)
            mstore(0xc4, _list)
            pop(staticcall(gas(), sload(0x0), 0x80, 0x64, 0x0, 0x40))
            let tokenAddr := mload(0x0)
            let price := mload(0x20)
            // 有价格才执行
            if gt(price, 0x0) {
                fee := div(mul(price, sub(0x2710, fee)), 0x2710)
                function x(cod) {
                    mstore(0x0, shl(0xe0, 0x5b4fb734))
                    mstore(0x4, cod)
                    revert(0x0, 0x24)
                }
                // 这是转加密货币
                if eq(tokenAddr, 0x1) {
                    if gt(price, callvalue()) { 
                        x(0x4)
                    }
                    pop(call(gas(), to, fee, 0x0, 0x0, 0x0, 0x0))
                    pop(call(gas(), sload(0x1), selfbalance(), 0x0, 0x0, 0x0, 0x0))
                }
                // 这是转ERC20代币
                if gt(tokenAddr, 0x1) {
                    mstore(0x80, shl(0xe0, 0x23b872dd)) // transferFrom(address,address,uint256)
                    function y(a, b, c, d) {
                        mstore(0x84, a)
                        mstore(0xa4, b)
                        mstore(0xc4, c)
                        if iszero(call(gas(), d, 0x0, 0x80, 0x64, 0x0, 0x0)) {
                            x(0x5)
                        }
                    }
                    y(origin(), address(), price, tokenAddr)
                    y(address(), to, fee, tokenAddr)
                    y(address(), sload(0x1), sub(price, fee), tokenAddr)
                }
            }
        }
    }
}