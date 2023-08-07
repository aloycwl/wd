// SPDX-License-Identifier: None
pragma solidity 0.8.19;
pragma abicoder v1;

import {Sign} from "Contracts/Util/Sign.sol";
import {DynamicPrice} from "Contracts/Util/DynamicPrice.sol";

contract ERC721 is Sign, DynamicPrice {
    bytes32 constant private STO = 0x79030946dd457157e4aa08fcb4907c422402e75f0f0ecb4f2089cb35021ff964;
    bytes32 constant private CNT = 0x5e423f2848a55862b54c89a4d1538a2d8aec99c1ee890237e17cdd6f0b5769d9;
    bytes32 constant private NA1 = 0xf81b3fd3135366259880acbe67fe529187df5bd875ef3a249ed4221ded1733a8;
    bytes32 constant private NA2 = 0xf2611493f75085dca50c1fd2ac8e34bc6d0eb7c274307efa54c50582314985bf;
    bytes32 constant private SB1 = 0x77f364795cb46b5690938fb39c14204236f4c9ec06ef0393ae0727afffac44e5;
    bytes32 constant private SB2 = 0x4bf7fd951d6e0483691bc47a65234a70074884918f0c2296cfe510ef5274b487;
    bytes32 constant private IN7 = 0x80ac58cd00000000000000000000000000000000000000000000000000000000;
    bytes32 constant private INM = 0x5b5e139f00000000000000000000000000000000000000000000000000000000;
    bytes32 constant private ADR = 0x8c66f12800000000000000000000000000000000000000000000000000000000;
    bytes32 constant private UIN = 0x4c200b1000000000000000000000000000000000000000000000000000000000;
    bytes32 constant private UID = 0x9975842600000000000000000000000000000000000000000000000000000000;
    bytes32 constant private STR = 0x99eec06400000000000000000000000000000000000000000000000000000000;
    bytes32 constant private STD = 0xc7070b5800000000000000000000000000000000000000000000000000000000;
    bytes32 constant private ENU = 0x82ff9d6f00000000000000000000000000000000000000000000000000000000;
    bytes32 constant private ENM = 0x6795d52600000000000000000000000000000000000000000000000000000000;
    bytes32 constant private APP = 0x8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925;
    bytes32 constant private AFA = 0x17307eab39ab6107e8899845ad3d59bd9653f200f220920489ca2b5937696c31;
    bytes32 constant private TTF = 0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
    bytes32 constant private UPD = 0xf8e1a15aba9398e019f0b49df1a4fde98ee17ae345cb5f6b5e2c27f5033e8ce7;

    event Transfer          (address indexed from, address indexed to, uint indexed id);
    event ApprovalForAll    (address indexed from, address indexed to, bool);
    event Approval          (address indexed from, address indexed to, uint indexed id);
    event MetadataUpdate    (uint id);

    //ERC20标准函数 
    constructor(address sto, string memory name_, string memory symbol_) {
        assembly {
            sstore(STO, sto)
            sstore(NA1, mload(name_))
            sstore(NA2, mload(add(name_, 0x20)))
            sstore(SB1, mload(symbol_))
            sstore(SB2, mload(add(symbol_, 0x20)))
        }
    }

    function supportsInterface(bytes4 a) external pure returns(bool val) {
        assembly {
            val := or(eq(a, IN7), eq(a, INM)) 
        }
    }

    function count() external view returns(uint val) {
        assembly {
            val := sload(CNT)
        }
    }

    function name() external view returns(string memory val) {
        assembly {
            val := mload(0x40)
            mstore(0x40, add(val, 0x40))
            mstore(val, sload(NA1))
            mstore(add(val, 0x20), sload(NA2))
        }
    }

    function symbol() external view returns(string memory val) {
        assembly {
            val := mload(0x40)
            mstore(0x40, add(val, 0x40))
            mstore(val, sload(SB1))
            mstore(add(val, 0x20), sload(SB2))
        }
    }

    function ownerOf(uint tid) external view returns(address val) { // 0x6352211e
        assembly {
            // addressData(address(), 0x0, id)
            mstore(0x80, ADR)
            mstore(0x84, address())
            mstore(0xa4, 0x0)
            mstore(0xc4, tid)
            pop(staticcall(gas(), sload(STO), 0x80, 0x64, 0x0, 0x20))
            val := mload(0x0)
        }
    }

    function balanceOf(address adr) external view returns (uint val) {
        assembly {
            // uintData(address(), addr, 0x0)
            mstore(0x80, UIN)
            mstore(0x84, address())
            mstore(0xa4, adr)
            mstore(0xc4, 0x0)
            pop(staticcall(gas(), sload(STO), 0x80, 0x64, 0x0, 0x20))
            val := mload(0x0)
        }
    }

    function tokenURI(uint tid) external view returns (string memory) {
        assembly {
            // stringData(address(), id)
            mstore(0x80, STR)
            mstore(0x84, address())
            mstore(0xa4, tid)
            pop(staticcall(gas(), sload(STO), 0x80, 0x44, 0xa0, 0x80))

            // string.concat()
            mstore(0x80, 0x20)
            mstore(0xa0, add(mload(0xc0), 0x20))
            mstore(0xc0, "ipfs://")
            return(0x80, 0xa0)
        }
    }

    function getApproved(uint tid) external view returns(address val) {
        assembly {
            // addressData(address(), 0x1, id)
            mstore(0x80, ADR)
            mstore(0x84, address())
            mstore(0xa4, 0x01)
            mstore(0xc4, tid)
            pop(staticcall(gas(), sload(STO), 0x80, 0x64, 0x00, 0x20))
            val := mload(0x00)
        }
    }

    function isApprovedForAll(address frm, address toa) external view returns(bool val) { // 0xe985e9c5
        assembly {
            // uintData(address(), from, to)
            mstore(0x80, UIN)
            mstore(0x84, address())
            mstore(0xa4, frm)
            mstore(0xc4, toa)
            pop(staticcall(gas(), sload(STO), 0x80, 0x64, 0x00, 0x20))
            val := mload(0x00)
        }
    }

    // 获取地址拥有的所有代币的数组
    function tokensOwned(address adr) external view returns(uint[] memory val) {
        uint len;

        // 先拿数组长度
        assembly {
            // uintEnum(address(), addr)
            mstore(0x80, ENU)
            mstore(0x84, address())
            mstore(0xa4, adr)
            pop(staticcall(gas(), sload(STO), 0x80, 0x84, 0x00, 0x40))
            len := mload(0x20)
        }

        val = new uint[](len);

        // 再每格插入
        assembly {
            // uintEnum(address(), addr)
            mstore(0x80, ENU)
            mstore(0x84, address())
            mstore(0xa4, adr)
            pop(staticcall(gas(), sload(STO), 0x80, 0x44, 0xa0, mul(add(len, 0x02), 0x20)))
            
            for { let i := 0x00 } lt(i, add(len, 0x02)) { i := add(i, 0x01) } {
                mstore(add(val, mul(i, 0x20)), mload(add(0xa0, mul(add(i, 0x01), 0x20))))
            }
        }
    }

    // gas: 67909
    function approve(address toa, uint tid) external { // 0x095ea7b3
        assembly {
            // uintData(address(), 0x0, id)
            mstore(0x80, UIN)
            // ownerOf(id)
            mstore(0x84, address())
            mstore(0xa4, 0x00)
            mstore(0xc4, tid)
            pop(staticcall(gas(), sload(STO), 0x80, 0x64, 0x00, 0x20))
            let oid := mload(0x00)

            // isApprovedForAll(oid, msg.sender)
            mstore(0xa4, oid)
            mstore(0xc4, caller())
            pop(staticcall(gas(), sload(STO), 0x80, 0x64, 0x00, 0x20))

            // require(msg.sender == ownerOf(id) || isApprovedForAll(ownerOf(id), msg.sender))
            if and(iszero(eq(caller(), oid)), iszero(mload(0x00))) {
                mstore(0x80, shl(0xe5, 0x461bcd)) 
                mstore(0x84, 0x20)
                mstore(0xA4, 0xd)
                mstore(0xC4, "Invalid owner")
                revert(0x80, 0x64)
            }

            // uintData(address(), 0x1, id, to)
            mstore(0x80, UID)
            mstore(0x84, address())
            mstore(0xa4, 0x1)
            mstore(0xc4, tid)
            mstore(0xe4, toa)
            pop(call(gas(), sload(STO), 0x00, 0x80, 0x84, 0x00, 0x00))

            // emit Approval()
            log4(0x00, 0x00, APP, oid, toa, tid)
        }
    }

    // gas: 61095
    function setApprovalForAll(address toa, bool bol) external {
        assembly {
            // uintData(address(), caller(), to, bol)
            mstore(0x80, UID)
            mstore(0x84, address())
            mstore(0xa4, caller())
            mstore(0xc4, toa)
            mstore(0xe4, bol)
            pop(call(gas(), sload(STO), 0x00, 0x80, 0x84, 0x00, 0x00))

            // emit ApprovalForAll()
            mstore(0x00, bol)
            log3(0x00, 0x20, AFA, origin(), toa)
        }
    }

    function safeTransferFrom(address frm, address toa, uint tid) external {
        transferFrom(frm, toa, tid); 
    }

    function safeTransferFrom(address frm, address toa, uint tid, bytes memory) external {
        transferFrom(frm, toa, tid); 
    }

    // gas: 165100
    function transferFrom(address, address toa, uint tid) public { // 0x23b872dd
        address oid;

        assembly {
            // uintData(address(), addr, 0x0)
            mstore(0x80, UIN)
            // ownerOf(id)
            mstore(0x84, address())
            mstore(0xa4, 0x00)
            mstore(0xc4, tid)
            pop(staticcall(gas(), sload(STO), 0x80, 0x64, 0x00, 0x20))
            oid := mload(0x00)

            // balanceOf(oid)
            mstore(0xa4, oid)
            mstore(0xc4, 0x00)
            pop(staticcall(gas(), sload(STO), 0x80, 0x64, 0x00, 0x20))
            let baf := mload(0x00)

            // balanceOf(to)
            mstore(0xa4, toa)
            pop(staticcall(gas(), sload(STO), 0x80, 0x64, 0x00, 0x20))
            let bat := mload(0x00)

            // getApproved(id)
            mstore(0xa4, 0x01)
            mstore(0xc4, tid)
            pop(staticcall(gas(), sload(STO), 0x80, 0x64, 0x0, 0x20))

            // require(所有者 || 被授权)
            if and(iszero(eq(mload(0x00), toa)), iszero(eq(oid, caller()))) {
                mstore(0x80, shl(0xe5, 0x461bcd)) 
                mstore(0x84, 0x20)
                mstore(0xA4, 0x10)
                mstore(0xC4, "Invalid approval")
                revert(0x80, 0x64)
            }

            // uintEnum(address(), oid, id, 1)
            mstore(0x80, ENM)
            // --tokensOwned()
            mstore(0x84, address())
            mstore(0xa4, oid)
            mstore(0xc4, tid)
            mstore(0xe4, 0x01)
            pop(call(gas(), sload(STO), 0x00, 0x80, 0x84, 0x00, 0x00))

            // ++tokensOwned()
            if gt(toa, 0x00) {
                mstore(0xa4, toa)
                mstore(0xe4, 0x00)
                pop(call(gas(), sload(STO), 0x00, 0x80, 0x84, 0x00, 0x00))
            }

            // uintData(address(), 1, id, 0)
            mstore(0x80, UID)
            // approval[id] = 0
            mstore(0x84, address())
            mstore(0xa4, 0x01)
            mstore(0xc4, tid)
            mstore(0xe4, 0x00)
            pop(call(gas(), sload(STO), 0x00, 0x80, 0x84, 0x00, 0x00))

            // ownerOf[id] = to
            mstore(0xa4, 0x00)
            mstore(0xc4, tid)
            mstore(0xe4, toa)
            pop(call(gas(), sload(STO), 0x00, 0x80, 0x84, 0x00, 0x00))

            // --balanceOf(oid)
            mstore(0xa4, oid)
            mstore(0xc4, 0x00)
            mstore(0xe4, sub(baf, 0x01))
            pop(call(gas(), sload(STO), 0x00, 0x80, 0x84, 0x00, 0x00))

            // ++balanceOf(to)
            if gt(toa, 0x00) {
                mstore(0xa4, toa)
                mstore(0xe4, add(0x01, bat))
                pop(call(gas(), sload(STO), 0x00, 0x80, 0x84, 0x00, 0x00))
            }

            // emit Transfer()
            log4(0x00, 0x00, TTF, oid, toa, tid)
        }
        checkSuspend(oid, toa);
    }

    //铸造功能，需要先决条件，也用来升级或合并
    function assetify(uint lis, uint tid, string memory uri, uint8 v, bytes32 r, bytes32 s) external payable {
        pay(address(this), lis, this.owner(), 0); // 若金额设定就支付
        checkSuspend(msg.sender, msg.sender); // 查有被拉黑不
        check(msg.sender, v, r, s); // 查签名
        
        assembly {
            if iszero(tid) { // 铸币
                // count++
                lis := add(sload(0x01), 0x01)
                sstore(CNT, lis)

                // uintEnum(address(), to, id, 0x0)
                mstore(0x80, ENM)
                // ++tokensOwned()
                mstore(0x84, address())
                mstore(0xa4, caller())
                mstore(0xc4, lis)
                mstore(0xe4, 0x0)
                pop(call(gas(), sload(STO), 0x00, 0x80, 0x84, 0x00, 0x00))

                // uintData(address(), addr, 0x0)
                mstore(0x80, UIN)
                // balanceOf(to)
                mstore(0x84, address())
                mstore(0xa4, caller())
                mstore(0xc4, 0x00)
                pop(staticcall(gas(), sload(STO), 0x80, 0x64, 0x00, 0x20))

                // uintData(address(), msg.sender, 0, balanceOf(msg.sender))
                mstore(0x80, UID)
                // ++balanceOf(msg.sender)
                mstore(0x84, address())
                mstore(0xa4, caller())
                mstore(0xc4, 0x00)
                mstore(0xe4, add(0x01, mload(0x00)))
                pop(call(gas(), sload(STO), 0x00, 0x80, 0x84, 0x00, 0x00))

                // ownerOf[id] = to
                mstore(0xa4, 0x00)
                mstore(0xc4, lis)
                mstore(0xe4, caller())
                pop(call(gas(), sload(STO), 0x00, 0x80, 0x84, 0x00, 0x00))
                
                // emit Transfer()
                log4(0x00, 0x00, TTF, 0x00, caller(), lis)
            }

            if gt(tid, 0x00) {  // 更新
                // emit MetadataUpdate(i)
                mstore(0x00, tid)
                log1(0x00, 0x20, UPD)
                lis := tid
            }         

            // stringData(address(), l, len, str1, str2)
            mstore(0x80, STD)
            // tokenURI[l] = u
            mstore(0x84, address())
            mstore(0xa4, lis)
            mstore(0xc4, mload(uri))
            mstore(0xe4, mload(add(uri, 0x20)))
            mstore(0x0104, mload(add(uri, 0x40)))
            pop(call(gas(), sload(STO), 0x00, 0x80, 0xa4, 0x00, 0x00))
        }
    }
    
    /******************************************************************************/
    /******************************************************************************/
    /******************************************************************************/
    /******************************************************************************/
    /******************************************************************************/
    /*****************************纯测试，实时部署前得删*****************************/
    /******************************************************************************/
    /******************************************************************************/
    /******************************************************************************/
    /******************************************************************************/
    /******************************************************************************/
    function assetify() external {
        uint l;
        assembly {         
            // 更新或铸新
            l := add(sload(CNT), 0x1)
            mstore(0x80, STD)

            // stringData(address(), l, len, str1, str2)
            mstore(0x84, address())
            mstore(0xa4, l)
            mstore(0xc4, 0x2f)
            mstore(0xe4, "QmVegGmha4L4pLPQAj7V46kQVc8EoGn")
            mstore(0x104, "wwKvbKvHbevRYD2")
            pop(call(gas(), sload(STO), 0x0, 0x80, 0xa4, 0x0, 0x0))

            // count++
            sstore(CNT, l)

            // uintEnum(address(), to, id, 0x0)
            mstore(0x80, ENM)
            // ++tokensOwned()
            mstore(0x84, address())
            mstore(0xa4, caller())
            mstore(0xc4, l)
            mstore(0xe4, 0x0)
            pop(call(gas(), sload(STO), 0x0, 0x80, 0x84, 0x0, 0x0))

            // uintData(address(), addr, 0x0)
            mstore(0x80, UIN)
            // balanceOf(to)
            mstore(0x84, address())
            mstore(0xa4, caller())
            mstore(0xc4, 0x0)
            pop(staticcall(gas(), sload(STO), 0x80, 0x64, 0x0, 0x20))

            // uintData(address(), msg.sender, 0, balanceOf(msg.sender))
            mstore(0x80, UID)
            // ++balanceOf(msg.sender)
            mstore(0x84, address())
            mstore(0xa4, caller())
            mstore(0xc4, 0x0)
            mstore(0xe4, add(0x1, mload(0x0)))
            pop(call(gas(), sload(STO), 0x0, 0x80, 0x84, 0x0, 0x0))

            // ownerOf[id] = to
            mstore(0xa4, 0x0)
            mstore(0xc4, l)
            mstore(0xe4, caller())
            pop(call(gas(), sload(STO), 0x0, 0x80, 0x84, 0x0, 0x0))
            
            // emit Transfer()
            log4(0x0, 0x0, TTF, 0x0, caller(), l)
        }
    }
}