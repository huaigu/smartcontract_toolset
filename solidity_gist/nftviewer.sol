// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

interface IERC721 {
    function ownerOf(uint256 tokenId) external view returns (address owner);
    function balanceOf(address owner) external view returns (uint256 balance);
    function nextTokenId() external view returns (uint256);
}

contract Nftviewer {
    address constant contractAddress = address(0x0000000000000000000000000000000000000000);
    
    /*
    @dev list all nft token ids by specify address, recommend (endIdx - startIdx) <= 1000
    anotherwise the contract will throw an error of out of gas.
     */
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
            // incase tokenId do not exist(layerzero compatible)
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

      /*
        @dev get onwers list, may failed if _end > totalSupply
        @param addr address of the contract
        @param startIdx start index of the token id
        @param endIdx end index of the token id
        @return address[] memory owners
       */
      function getNFTOwners(address nftContractAddress, uint256 _start, uint256 _end) external view returns(address[] memory) {
         require(nftContractAddress != address(0), "contract can not be zero address");
         require(_end >_start, "end index should great than start index");
         IERC721 nftContract = IERC721(nftContractAddress);

         address[] memory owners = new address[](_end - _start + 1);
         uint ownerIndex = 0;
         for(uint256 i=_start; i<=_end; ++i){
             owners[ownerIndex] = nftContract.ownerOf(i);
             ++ownerIndex;
         }

         return owners;
    }
}
