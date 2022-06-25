//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;
pragma abicoder v2;

import "hardhat/console.sol";
import "./OnChainWallet.sol";

interface Predicate {

  function check(OnChainWallet.Call memory call, bytes memory predicateParams) external;
}

contract PredicateImplV1 is Predicate {
  struct PredicateData {
    address allowedAddress;
    bytes4 allowedMethod;
  }

  function check(OnChainWallet.Call memory call, bytes memory predicateParams) override external view {
    (PredicateData memory _predicateData) = abi.decode(predicateParams, (PredicateData));
    if (_predicateData.allowedAddress != address(0)) {
      require(_predicateData.allowedAddress == call.to, "Unallowed account");
    }
    if (_predicateData.allowedMethod != bytes4(0x0)) {
      bytes4 methodSignature =
      call.data[0] |
      (bytes4(call.data[1]) >> 8) |
      (bytes4(call.data[2]) >> 16) |
      (bytes4(call.data[3]) >> 24);
      require(_predicateData.allowedMethod == methodSignature, "Unallowed method");
    }
  }

}
