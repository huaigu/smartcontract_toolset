pragma solidity ^0.8.0;

contract BaseContact1 {

    function getColor() virtual public view returns(string memory color) {
        return "red";
    }

    function makeColor() virtual public pure {
        
    }
}

contract BaseContact2 {
 
    function getColor() virtual public view returns(string memory color) {
        return "yellow";
    }

    function makeColor() virtual public pure {
        
    }
}

contract ImplContract is BaseContact1, BaseContact2 {

    // override only
    function getColor() public override(BaseContact1, BaseContact2) view returns(string memory color){
        // mix colors
        return string(abi.encodePacked(BaseContact2.getColor(), "&" ,BaseContact1.getColor()));
    }

    // override + virtual，child 可以继续override
    function makeColor() public virtual override(BaseContact1, BaseContact2) pure {

    }
}