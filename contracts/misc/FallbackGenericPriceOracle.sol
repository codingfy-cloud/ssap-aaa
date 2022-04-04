pragma solidity 0.6.12;

import {Ownable} from "../dependencies/openzeppelin/contracts/Ownable.sol";

interface GenericOracleI {
    // ganache
    event AssetPriceUpdated(address _asset, uint256 _price, uint256 timestamp);
    event EthPriceUpdated(uint256 _price, uint256 timestamp);

    function getAssetPrice(address _asset) external view returns (uint256);

    function getEthUsdPrice() external view returns (uint256);
}

contract FallbackGenericPriceOracle is GenericOracleI, Ownable {
    mapping(address => uint256) mockData;
    address wNative;

    constructor(address _wNative) public {
        wNative = _wNative;
    }

    function updateReferenceData(address _asset, uint256 _price) external onlyOwner {
        mockData[_asset] = _price;
        if (_asset == wNative) {
            emit EthPriceUpdated(_price, block.timestamp);
        } else {
            emit AssetPriceUpdated(_asset, _price, block.timestamp);
        }
    }

    function getAssetPrice(address _asset) external view override returns (uint256) {
        return mockData[_asset];
    }

    function getEthUsdPrice() external view override returns (uint256) {
        return mockData[wNative];
    }

    function setWNative(address _wNative) external onlyOwner {
        wNative = _wNative;
    }
}
