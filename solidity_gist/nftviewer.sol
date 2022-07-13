// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

interface IERC721 {
    function ownerOf(uint256 tokenId) external view returns (address owner);
    function balanceOf(address owner) external view returns (uint256 balance);
    function nextTokenId() external view returns (uint256);
}

contract Nftviewer {
    address constant contractAddress = address(0xAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA);
    function ListNfts(address addr, uint256 startIdx, uint256 endIdx) external view returns (uint256[] memory){
       
        address owner = addr;
        IERC721 contra = IERC721(contractAddress);

        uint256[] memory tokens;
        uint256 ownerBalance = contra.balanceOf(owner);
        if(ownerBalance == 0) return tokens;
        tokens = new uint256[] (ownerBalance);
        uint256 arrayIndex = 0;
        for(uint256 i=startIdx; i < endIdx; ++i){
            // address tokenOwnerOfI;
            try contra.ownerOf(i) returns (address tokenOwnerAddr) {
                if( tokenOwnerAddr == owner){
                    tokens[arrayIndex] = i;
                    arrayIndex ++;
                }
            }catch(bytes memory ){
                
            }
        }
        
        return tokens;
    }
}
