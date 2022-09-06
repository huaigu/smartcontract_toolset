不管是UUPS还是TransparentProxy，核心都是ERC1967Proxy.sol
Blockchain Explorer检测到了EIP1967实现，就会显示Read as Proxy 和 Write as Proxy两个额外的按钮。
因为采用EIP1967协议的合约，在固定的slot位置存储了Impl合约的地址，能够被浏览器获取。

