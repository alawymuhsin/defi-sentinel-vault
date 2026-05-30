// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title DeFiSentinelVault
 * @notice Staking vault untuk OPN Chain - DeFi Sentinel
 * @dev Users stake IOPN tokens, earn rewards over time
 */
contract DeFiSentinelVault {

    // ============ State Variables ============

    address public owner;
    address public iopnToken;  // IOPN token address (native or ERC-20)

    uint256 public totalStaked;
    uint256 public rewardRate = 500;         // 5% APR (basis points)
    uint256 public constant PRECISION = 1e18;
    uint256 public constant BASIS_POINTS = 10000;
    uint256 public minStake = 0.01 ether;
    uint256 public maxStake = 10000 ether;

    struct UserInfo {
        uint256 staked;
        uint256 rewardDebt;
        uint256 lastStakeTime;
        uint256 totalRewards;
    }

    mapping(address => UserInfo) public users;
    address[] public stakers;

    uint256 public lastRewardUpdate;
    uint256 public accRewardPerShare;

    // ============ Events ============

    event Staked(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);
    event RewardClaimed(address indexed user, uint256 reward);
    event RewardRateUpdated(uint256 newRate);

    // ============ Modifiers ============

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    // ============ Constructor ============

    constructor() {
        owner = msg.sender;
        lastRewardUpdate = block.timestamp;
    }

    // ============ Core Functions ============

    /**
     * @notice Stake IOPN tokens
     */
    function stake() external payable {
        require(msg.value >= minStake, "Below minimum stake");
        require(msg.value <= maxStake, "Above maximum stake");

        UserInfo storage user = users[msg.sender];

        // Update rewards first
        if (user.staked > 0) {
            uint256 pending = (user.staked * accRewardPerShare / PRECISION) - user.rewardDebt;
            if (pending > 0) {
                user.totalRewards += pending;
            }
        }

        // Update pool
        _updatePool();

        // Add to stakers list if first time
        if (user.staked == 0) {
            stakers.push(msg.sender);
        }

        user.staked += msg.value;
        user.rewardDebt = user.staked * accRewardPerShare / PRECISION;
        user.lastStakeTime = block.timestamp;
        totalStaked += msg.value;

        emit Staked(msg.sender, msg.value);
    }

    /**
     * @notice Withdraw staked tokens
     */
    function withdraw(uint256 amount) external {
        UserInfo storage user = users[msg.sender];
        require(user.staked >= amount, "Insufficient stake");

        // Update rewards
        _updatePool();
        uint256 pending = (user.staked * accRewardPerShare / PRECISION) - user.rewardDebt;
        if (pending > 0) {
            user.totalRewards += pending;
        }

        user.staked -= amount;
        user.rewardDebt = user.staked * accRewardPerShare / PRECISION;
        totalStaked -= amount;

        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Transfer failed");

        emit Withdrawn(msg.sender, amount);
    }

    /**
     * @notice Claim accumulated rewards
     */
    function claimReward() external {
        UserInfo storage user = users[msg.sender];
        require(user.staked > 0, "No stake");

        _updatePool();
        uint256 pending = (user.staked * accRewardPerShare / PRECISION) - user.rewardDebt;
        uint256 totalReward = pending + user.totalRewards;

        require(totalReward > 0, "No rewards");

        user.totalRewards = 0;
        user.rewardDebt = user.staked * accRewardPerShare / PRECISION;

        (bool success, ) = payable(msg.sender).call{value: totalReward}("");
        require(success, "Transfer failed");

        emit RewardClaimed(msg.sender, totalReward);
    }

    // ============ View Functions ============

    /**
     * @notice Get pending rewards for a user
     */
    function pendingReward(address _user) external view returns (uint256) {
        UserInfo storage user = users[_user];
        if (user.staked == 0) return 0;

        uint256 currentAccReward = accRewardPerShare;
        if (totalStaked > 0) {
            uint256 timeDiff = block.timestamp - lastRewardUpdate;
            uint256 reward = (totalStaked * rewardRate * timeDiff) / (365 days * BASIS_POINTS);
            currentAccReward = accRewardPerShare + (reward * PRECISION / totalStaked);
        }

        uint256 pending = (user.staked * currentAccReward / PRECISION) - user.rewardDebt;
        return pending + user.totalRewards;
    }

    /**
     * @notice Get total number of stakers
     */
    function getStakerCount() external view returns (uint256) {
        return stakers.length;
    }

    /**
     * @notice Get staker address by index
     */
    function getStaker(uint256 index) external view returns (address) {
        require(index < stakers.length, "Out of bounds");
        return stakers[index];
    }

    /**
     * @notice Get contract balance
     */
    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }

    // ============ Admin Functions ============

    function setRewardRate(uint256 _rate) external onlyOwner {
        require(_rate <= 5000, "Rate too high"); // max 50%
        _updatePool();
        rewardRate = _rate;
        emit RewardRateUpdated(_rate);
    }

    function setMinStake(uint256 _min) external onlyOwner {
        minStake = _min;
    }

    function setMaxStake(uint256 _max) external onlyOwner {
        maxStake = _max;
    }

    function fundRewards() external payable onlyOwner {
        require(msg.value > 0, "Must send funds");
    }

    // ============ Internal Functions ============

    function _updatePool() internal {
        if (block.timestamp <= lastRewardUpdate) return;

        if (totalStaked > 0) {
            uint256 timeDiff = block.timestamp - lastRewardUpdate;
            uint256 reward = (totalStaked * rewardRate * timeDiff) / (365 days * BASIS_POINTS);
            accRewardPerShare += (reward * PRECISION / totalStaked);
        }

        lastRewardUpdate = block.timestamp;
    }

    // ============ Fallback ============

    receive() external payable {}
    fallback() external payable {}
}
