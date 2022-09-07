pragma solidity 0.8.11;
interface IBEP20 { 
	function totalSupply() external view returns (uint256);
	function balanceOf(address account) external view returns (uint256);
	function transfer(address recipient, uint256 amount) external returns (bool);
	function allowance(address owner, address spender) external view returns (uint256);
	function approve(address spender, uint256 amount) external returns (bool);
	function transferFrom( address sender, address recipient, uint256 amount ) external returns (bool);
	function mint(address account, uint256 amount) external returns (bool);
	function burn(address account, uint256 amount) external returns (bool);
	function addOperator(address minter) external returns (bool);
	function removeOperator(address minter) external returns (bool);
	event Transfer(address indexed from, address indexed to, uint256 value);
	event Approval( address indexed owner, address indexed spender, uint256 value );
} 
library SafeBEP20 {
    using SafeMath for uint256;
    using Address for address;
    function safeTransfer(IBEP20 token, address to, uint256 value) internal {
        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }
    function safeTransferFrom(IBEP20 token, address from, address to, uint256 value) internal {
        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }
    function safeApprove(IBEP20 token, address spender, uint256 value) internal {
        require((value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeBEP20: approve from non-zero to non-zero allowance"
        );
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }
    function safeIncreaseAllowance(IBEP20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(value);
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }
    function safeDecreaseAllowance(IBEP20 token, address spender, uint256 value) internal {
        // uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeBEP20: decreased allowance below zero");
        uint256 newAllowance = token.allowance(address(this), spender).sub(value);
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }
    function callOptionalReturn(IBEP20 token, bytes memory data) private {
        require(address(token).isContract(), "SafeBEP20: call to non-contract");
        (bool success, bytes memory returndata) = address(token).call(data);
        require(success, "SafeBEP20: low-level call failed");
        if (returndata.length > 0) { 
            require(abi.decode(returndata, (bool)), "SafeBEP20: ERC20 operation did not succeed");
        }
    }
}
library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        uint256 c = a - b;
        return c;
    }
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, "SafeMath: division by zero");
        uint256 c = a / b;
        return c;
    }
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0, "SafeMath: modulo by zero");
        return a % b;
    }
}
library Address {
    function isContract(address account) internal view returns (bool) {
        uint256 size;
        assembly { size := extcodesize(account) }
        return size > 0;
    }
} 
interface IERC165 {
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}
abstract contract Context {
    function _msgSender() internal view virtual returns (address) { return msg.sender;}
    function _msgData() internal view virtual returns (bytes calldata) {
        this;
        return msg.data;
    }
}
abstract contract ERC165 is IERC165 {
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) { return interfaceId == type(IERC165).interfaceId; }
}
interface IAccessControl {
    function hasRole(bytes32 role, address account) external view returns (bool);
    function getRoleAdmin(bytes32 role) external view returns (bytes32);
    function grantRole(bytes32 role, address account) external;
    function revokeRole(bytes32 role, address account) external;
    function renounceRole(bytes32 role, address account) external;
}
abstract contract AccessControl is Context, IAccessControl, ERC165 {
    struct RoleData {
        mapping(address => bool) members;
        bytes32 adminRole;
    }
    mapping(bytes32 => RoleData) private _roles;
    bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
    event RoleAdminChanged(
        bytes32 indexed role,
        bytes32 indexed previousAdminRole,
        bytes32 indexed newAdminRole
    );
    event RoleGranted(
        bytes32 indexed role,
        address indexed account,
        address indexed sender
    );
    event RoleRevoked(
        bytes32 indexed role,
        address indexed account,
        address indexed sender
    );
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool){
        return
            interfaceId == type(IAccessControl).interfaceId ||
            super.supportsInterface(interfaceId);
    }
    function hasRole(bytes32 role, address account) public view override returns (bool) { return _roles[role].members[account]; }
    function getRoleAdmin(bytes32 role) public view override returns (bytes32) { return _roles[role].adminRole; }
    function grantRole(bytes32 role, address account) external virtual override { 
        require( hasRole(getRoleAdmin(role), _msgSender()), "AccessControl: sender must be an admin to grant");
        _grantRole(role, account);
    }
    function revokeRole(bytes32 role, address account) external virtual override {
        require( hasRole(getRoleAdmin(role), _msgSender()), "AccessControl: sender must be an admin to revoke");
        _revokeRole(role, account);
    }
    function renounceRole(bytes32 role, address account) external virtual override
    {
        require( account == _msgSender(), "AccessControl: can only renounce roles for self" );
        _revokeRole(role, account);
    }
    function _setupRole(bytes32 role, address account) internal virtual { _grantRole(role, account); }
    function _grantRole(bytes32 role, address account) private {
        if (!hasRole(role, account)) {
            _roles[role].members[account] = true;
            emit RoleGranted(role, account, _msgSender());
        }
    }
    function _revokeRole(bytes32 role, address account) private {
        if (hasRole(role, account)) {
            _roles[role].members[account] = false;
            emit RoleRevoked(role, account, _msgSender());
        }
    }
}
interface Reward { 
	function transferToken(IBEP20 _token, address _to, uint256 _amount) external;
}
contract Stake is AccessControl {
    using SafeMath for uint;
    using SafeBEP20 for IBEP20;
    IBEP20 public HE;
    Reward public RE;
    bytes32 public constant CREATOR_ADMIN = keccak256("CREATOR_ADMIN");
    struct UserInfo {  
        uint256 amount;     // How many HE tokens the user has provided.
        uint256 rewardDebt; // Reward debt. See explanation below.
        uint256 pendingDebt;
    }
    mapping(uint256 => mapping(address => bool)) public boolAddWallet;
    mapping(uint256 => mapping(address => address)) public addressStake;
    uint256 public timeLockWithdraw = 259200;
    uint256 public timeLockClaim = 259200;
    uint256 public bonusEndBlock;
    // Info of each pool.
    struct PoolInfo {
        IBEP20 heToken;           // Address of HE token contract.
        uint256 allocPoint;       // How many allocation points assigned to this pool. HE to distribute per block.
        uint256 lastRewardBlock;  // Last block number that HE distribution occurs.
        uint256 accHePerShare; // Accumulated HE per share, times 1e18. See below.
        uint256 balancePool;
    }
    struct WithdrawInfo {
        uint256 amount;
        uint256 blockTime;
        uint256 status;
    }
     struct ClaimInfo {
        uint256 amount;
        uint256 blockTime;
        uint256 status;
    }
    uint256 public HePerBlock;
    uint256 public constant BONUS_MULTIPLIER = 1;
    // Info of each pool.
    PoolInfo[] public poolInfo;
    // Info of each user that stakes HE tokens.
    mapping (uint256 => mapping (address => UserInfo)) public userInfo;
    mapping (uint256 => mapping (address => WithdrawInfo[])) public withdrawInfo;
    mapping (uint256 => mapping (address => ClaimInfo[])) public claimInfo;
    // Total allocation poitns. Must be the sum of all allocation points in all pools.
    uint256 public totalAllocPoint = 0;
    // The block number when LUCKY mining starts.
    uint256 public startBlock;

    event Deposit(address indexed user, uint256 indexed pid, uint256 amount, uint256 blockTime);
    event Withdraw(address indexed user, uint256 indexed pid, uint256 amount, uint256 blockTime);
    event Claim(address indexed user, uint256 indexed pid, uint256 reward, uint256 blockTime);
    event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount, uint256 blockTime);
    event ReInvestment(address indexed user, uint256 indexed pid, uint256 reInvestment, uint256 blockTime);
    event AddWallet(address indexed user, uint256 indexed pid, address Walletreceive, uint256 blockTime);
    constructor(
        address minter,
        address _HE,
        uint256 _hePerBlock,
        uint256 _startBlock,
        uint256 _bonusEndBlock,
        address _reward
    ) {
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _setupRole(CREATOR_ADMIN, minter);
        HE = IBEP20(_HE);
        HePerBlock = _hePerBlock;
        startBlock = _startBlock;
        bonusEndBlock = _bonusEndBlock;  
        RE = Reward(_reward);
    }
    function poolLength() external view returns (uint256) {
        return poolInfo.length;
    }

    function changeTimeLockWithdraw(uint256 _timeLock) external {
        require(hasRole(DEFAULT_ADMIN_ROLE, address(msg.sender)), "Caller is not a owner");
        timeLockWithdraw = _timeLock;
    }
    function changeTimeLockClaim(uint256 _timeLock) external {
        require(hasRole(DEFAULT_ADMIN_ROLE, address(msg.sender)), "Caller is not a owner");
        timeLockClaim = _timeLock;
    }
    function changeHePerBlock(uint256 _hePerBlock) external {
        require(hasRole(DEFAULT_ADMIN_ROLE, address(msg.sender)), "Caller is not a owner");
        massUpdatePools();
        HePerBlock = _hePerBlock;
    }
    function getWithdrawByAddress(uint256 _pid, address _address) external view returns (WithdrawInfo[]  memory) {
        return withdrawInfo[_pid][_address];
    }
    function getClaimByAddress(uint256 _pid, address _address) external view returns (ClaimInfo[]  memory) {
        return claimInfo[_pid][_address];
    }
    function add(uint256 _allocPoint, IBEP20 _heToken, bool _withUpdate) external {
        require(hasRole(DEFAULT_ADMIN_ROLE, address(msg.sender)), "Caller is not a owner");
        require(block.number > startBlock, 'has not started yet');
        if (_withUpdate) {
            massUpdatePools();
        }
        uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
        totalAllocPoint = totalAllocPoint.add(_allocPoint);
        poolInfo.push(PoolInfo({
            heToken: _heToken,
            allocPoint: _allocPoint,
            lastRewardBlock: lastRewardBlock,
            accHePerShare: 0,
            balancePool: 0
        }));
    }
    function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) external {
        require(hasRole(DEFAULT_ADMIN_ROLE, address(msg.sender)), "Caller is not a owner");
        if (_withUpdate) {
            massUpdatePools();
        }
        totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
        poolInfo[_pid].allocPoint = _allocPoint;
    }
    function addViewWallet(uint256 _pid, address _receive) external {
        require(!boolAddWallet[_pid][_receive], "Wallet has been added");
        addressStake[_pid][address(_receive)] = msg.sender;
        boolAddWallet[_pid][_receive] = true;
        emit AddWallet(msg.sender, _pid, address(_receive), block.timestamp);
    }
    function getViewWallet(uint256 _pid, address _receive) external view returns (uint256){
        address staker = addressStake[_pid][_receive];
        UserInfo storage user = userInfo[_pid][staker];
        uint256 amount = user.amount;
        return amount;
    }
    // Return reward multiplier over the given _from to _to block.
    function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
        if (_to <= bonusEndBlock) {
            return _to.sub(_from).mul(BONUS_MULTIPLIER);
        } else if (_from >= bonusEndBlock) {
            return _to.sub(_from);
        } else {
            return bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(
                _to.sub(bonusEndBlock)
            );
        }
    }
    // reward prediction at specific block
    function getRewardPerBlock(uint blockNumber) public view returns (uint256) {
        if (blockNumber >= startBlock){
            return HePerBlock;
        } else {
            return 0;
        }
    }
    // View function to see pending Lucky on frontend.
    function pendingToken(uint256 _pid, address _user) external view returns (uint256) {
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][_user];
        uint256 accHePerShare = pool.accHePerShare;
        uint256 lpSupply = pool.balancePool;
        if (block.number > pool.lastRewardBlock && lpSupply != 0) {
            uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
            uint256 rewardThisBlock = getRewardPerBlock(block.number);
            uint256 heReward = multiplier.mul(rewardThisBlock).mul(pool.allocPoint).div(totalAllocPoint);
            accHePerShare = accHePerShare.add(heReward.mul(1e18).div(lpSupply));
        }
        uint256 rewardHe = user.amount.mul(accHePerShare).div(1e18).sub(user.rewardDebt).add(user.pendingDebt);
        return rewardHe;
    }
    // Update reward vairables for all pools. Be careful of gas spending!
    function massUpdatePools() public {
        uint256 length = poolInfo.length;
        for (uint256 pid = 0; pid < length; ++pid) {
            updatePool(pid);
        }
    }

    // Update reward variables of the given pool to be up-to-date.
    function updatePool(uint256 _pid) public {
        PoolInfo storage pool = poolInfo[_pid];
        if (block.number <= pool.lastRewardBlock) {
            return; 
        }
        uint256 lpSupply = pool.balancePool;
        if (lpSupply == 0) {
            pool.lastRewardBlock = block.number;
            return;
        }
        uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
        uint256 rewardThisBlock = getRewardPerBlock(block.number);
        uint256 heReward = multiplier.mul(rewardThisBlock).mul(pool.allocPoint).div(totalAllocPoint);
        pool.accHePerShare = pool.accHePerShare.add(heReward.mul(1e18).div(lpSupply));
        pool.lastRewardBlock = block.number;
    }
    // Deposit HE tokens to MasterChef for HE allocation.
    function deposit(uint256 _pid, uint256 _amount) external {
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][msg.sender];
        updatePool(_pid);
        if (user.amount > 0) {
            uint256 pending = user.amount.mul(pool.accHePerShare).div(1e18).sub(user.rewardDebt);
            if(pending > 0){
                user.pendingDebt = user.pendingDebt.add(pending);
            }
        } 
        if(_amount > 0){
            pool.heToken.safeTransferFrom(address(msg.sender), address(this), _amount);
            pool.balancePool = pool.balancePool.add(_amount);
            user.amount = user.amount.add(_amount);
        }
        user.rewardDebt = user.amount.mul(pool.accHePerShare).div(1e18);
        emit Deposit(msg.sender, _pid, _amount, block.timestamp);
    }

    // Withdraw HE tokens.
    function pendingWithdraw(uint256 _pid, uint256 _amount) external {
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][msg.sender];
        require(user.amount >= _amount, "withdraw: not good");
        updatePool(_pid);
        uint256 pending = user.amount.mul(pool.accHePerShare).div(1e18).sub(user.rewardDebt);
        user.amount = user.amount.sub(_amount);
        user.rewardDebt = user.amount.mul(pool.accHePerShare).div(1e18);
        pool.balancePool = pool.balancePool.sub(_amount);
        withdrawInfo[_pid][msg.sender].push(WithdrawInfo(_amount, block.timestamp, 0)); 
        user.pendingDebt = user.pendingDebt.add(pending);
    }

    function withdraw(uint256 _pid, uint256 _id) external {
        PoolInfo storage pool = poolInfo[_pid];
        uint256 status = withdrawInfo[_pid][msg.sender][_id].status;
        uint256 amount = withdrawInfo[_pid][msg.sender][_id].amount;
        uint256 timeWithdraw = withdrawInfo[_pid][msg.sender][_id].blockTime;
        require(status == 0, 'You have withdrawn');
        // require(amount >= 0 , 'withdraw: not good');
        require((block.timestamp - timeWithdraw) > timeLockWithdraw, 'you are still in lock');
        withdrawInfo[_pid][msg.sender][_id].status = 1;
        pool.heToken.safeTransfer(address(msg.sender), amount);
        emit Withdraw(msg.sender, _pid, amount, block.timestamp);
    }
    function pendingClaim(uint256 _pid, uint256 _amount) external {
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][msg.sender];
        // require(user.amount >= 0, "withdraw: not good");
        updatePool(_pid);
        uint256 pending = user.amount.mul(pool.accHePerShare).div(1e18).sub(user.rewardDebt);
        user.rewardDebt = user.amount.mul(pool.accHePerShare).div(1e18);
        require(user.pendingDebt.add(pending) >= _amount, "Claim: not good");
        user.pendingDebt = user.pendingDebt.add(pending).sub(_amount);
        claimInfo[_pid][msg.sender].push(ClaimInfo(_amount, block.timestamp, 0)); 
    }
    function claim(uint256 _pid, uint256 _id) external {
        uint256 status = claimInfo[_pid][msg.sender][_id].status;
        uint256 amount = claimInfo[_pid][msg.sender][_id].amount;
        uint256 timeWithdraw = claimInfo[_pid][msg.sender][_id].blockTime;
        require(status == 0, 'You have withdrawn');
        // require(amount >= 0 , 'withdraw: not good');
        require((block.timestamp - timeWithdraw) > timeLockClaim, 'you are still in lock');
        claimInfo[_pid][msg.sender][_id].status = 1;
        RE.transferToken(HE,address(msg.sender), amount);
        emit Claim(msg.sender, _pid, amount, block.timestamp);
    }
    function reInvestment(uint256 _pid, uint256 _amount) external {
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][msg.sender];
        // require(user.amount >= 0, "amount: not good");
        require(pool.heToken == HE, "Token does not support restake");
        updatePool(_pid);
        uint256 pending = user.amount.mul(pool.accHePerShare).div(1e18).sub(user.rewardDebt);
        require(user.pendingDebt.add(pending) >= _amount, "Claim: not good");
        user.pendingDebt = user.pendingDebt.add(pending).sub(_amount);
        pool.balancePool = pool.balancePool.add(_amount);
        user.amount = user.amount.add(_amount);
        user.rewardDebt = user.amount.mul(pool.accHePerShare).div(1e18);
        RE.transferToken(HE,address(this), _amount);
        emit ReInvestment(msg.sender, _pid, _amount, block.timestamp);
    }
    // Withdraw without caring about rewards. EMERGENCY ONLY.
    function emergencyWithdraw(uint256 _pid) external {
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][msg.sender];
        withdrawInfo[_pid][msg.sender].push(WithdrawInfo(user.amount, block.timestamp, 0));
        pool.balancePool = pool.balancePool.sub(user.amount);
        emit EmergencyWithdraw(msg.sender, _pid, user.amount, block.timestamp);
        user.amount = 0;
        user.rewardDebt = 0;
        user.pendingDebt = 0;
    }
}