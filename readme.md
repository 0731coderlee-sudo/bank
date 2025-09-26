# 🏦 Bank Smart Contract System

一个基于 Solidity 的银行智能合约系统，包含 Bank、BigBank 和 Admin 合约的完整实现，支持存款、提取和管理员权限转移功能。

## 📋 项目概述

本项目实现了一个分层的银行合约系统：

- **IBank 接口**: 定义银行合约的标准接口
- **Bank 合约**: 基础银行功能实现
- **BigBank 合约**: 继承 Bank，添加最小存款限制和管理员转移功能
- **Admin 合约**: 管理员合约，可以调用 IBank 接口管理资金

## 🏗️ 架构设计

```
IBank (接口)
    ↑
Bank (基础实现)
    ↑
BigBank (扩展功能)
    ↑
Admin (管理合约) → 调用 IBank 接口
```

## 📁 项目结构

```
bank/
├── src/
│   ├── IBank.sol          # 银行接口定义
│   ├── Bank.sol           # 基础银行合约
│   ├── BigBank.sol        # 扩展银行合约
│   └── Admin.sol          # 管理员合约
├── script/
│   ├── DeployAdmin.s.sol  # Admin 合约部署脚本
│   └── DeployAll.s.sol    # 全量部署脚本
├── test/
│   └── BigBankTest.t.sol  # 单元测试
└── README.md
```

## 🚀 快速开始

### 环境要求

- [Foundry](https://book.getfoundry.sh/getting-started/installation)
- Node.js (用于 Anvil)

### 安装依赖

```bash
# 克隆项目
git clone <repository-url>
cd bank

# 安装 Foundry 依赖
forge install

# 编译合约
forge build
```

### 启动本地测试网络

```bash
# 启动 Anvil 本地网络
anvil
```

Anvil 将在 `http://localhost:8545` 启动，并提供以下测试账户：

- **Account #0**: `0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266` (10000 ETH)
- **Account #1**: `0x70997970C51812dc3A010C7d01b50e0d17dc79C8` (10000 ETH)
- **Account #2**: `0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC` (10000 ETH)

## 🧪 测试

### 运行单元测试

```bash
# 运行所有测试
forge test -vv

# 运行特定测试合约
forge test -vv --match-contract BigBankTest
```

### 完整测试流程

#### 1. 部署合约

```bash
# 部署 BigBank 合约
forge create --rpc-url http://localhost:8545 \
    --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 \
    src/BigBank.sol:BigBank

# 部署 Admin 合约
forge script script/DeployAdmin.s.sol \
    --rpc-url http://localhost:8545 \
    --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 \
    --broadcast
```

#### 2. 用户存款测试

```bash
# 用户1存款 0.01 ETH
cast send <BIGBANK_ADDRESS> "deposit()" \
    --value 0.01ether \
    --private-key 0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d \
    --rpc-url http://localhost:8545

# 用户2存款 0.02 ETH  
cast send <BIGBANK_ADDRESS> "deposit()" \
    --value 0.02ether \
    --private-key 0x5de4111afa1a4b94908f83103eb1f1706367c2e68ca870fc3fb9a804cdab365a \
    --rpc-url http://localhost:8545

# 用户3存款 0.03 ETH
cast send <BIGBANK_ADDRESS> "deposit()" \
    --value 0.03ether \
    --private-key 0x7c852118294e51e653712a81e05800f419141751be58f605c371e15141b007a6 \
    --rpc-url http://localhost:8545
```

#### 3. 管理员权限转移

```bash
# 将 BigBank 管理员转移给 Admin 合约
cast send <BIGBANK_ADDRESS> "transferAdmin(address)" <ADMIN_ADDRESS> \
    --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 \
    --rpc-url http://localhost:8545
```

#### 4. Admin 合约提取资金

```bash
# Admin 合约调用 IBank 接口提取资金
cast send <ADMIN_ADDRESS> "adminWithdraw(address)" <BIGBANK_ADDRESS> \
    --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 \
    --rpc-url http://localhost:8545
```

#### 5. 验证结果

```bash
# 检查 BigBank 余额（应该为 0）
cast balance <BIGBANK_ADDRESS> --rpc-url http://localhost:8545

# 检查 Admin 合约余额（应该包含所有提取的资金）
cast balance <ADMIN_ADDRESS> --rpc-url http://localhost:8545
```

## 📊 测试结果示例

### 成功的完整测试流程

```
🏦 BigBank + Admin 完整测试
=========================

合约地址:
BigBank: 0xc5a5C42992dECbae36851359345FE25997F5C42d
Admin: 0x09635F643e140090A9A8Dcd712eD6285858ceBef

1️⃣ 用户存款阶段
User1 存入 0.01 ETH
✅ Transaction: 0x123...

User2 存入 0.02 ETH  
✅ Transaction: 0x456...

User3 存入 0.03 ETH
✅ Transaction: 0x789...

📊 存款后余额: 60000000000000000 (0.06 ETH)

2️⃣ 转移管理员权限
✅ Transaction: 0xabc...

3️⃣ Admin 提取资金
提取前 Admin 余额: 0
执行 adminWithdraw...
✅ Transaction: 0xdef...

✅ 最终结果:
BigBank 余额: 0
Admin 余额: 60000000000000000 (0.06 ETH)

🎉 测试完成!
```

## 🔧 合约功能

### IBank 接口
```solidity
interface IBank {
    event Deposit(address indexed user, uint amount);
    event Withdrawal(address indexed user, uint amount);
    
    function deposit() external payable;
    function withdraw() external;
    function getBalance() external view returns (uint);
}
```

### Bank 合约特性
- ✅ 实现 IBank 接口
- ✅ 基础存款和提取功能
- ✅ 管理员权限控制
- ✅ 事件发射

### BigBank 合约特性
- ✅ 继承 Bank 合约
- ✅ 最小存款限制 (0.001 ETH)
- ✅ Modifier 权限控制
- ✅ 管理员转移功能
- ✅ 增强的安全检查

### Admin 合约特性
- ✅ 调用 IBank 接口
- ✅ 资金管理功能
- ✅ 权限控制
- ✅ 接收 ETH 功能

## 🛡️ 安全特性

1. **权限控制**: 使用 `onlyOwner` modifier 限制关键操作
2. **最小存款限制**: BigBank 要求存款 > 0.001 ether
3. **零地址检查**: 防止转移管理员给零地址
4. **重复检查**: 防止转移给当前管理员
5. **调用安全**: 使用 `call` 函数进行安全的 ETH 转账

## 📈 Gas 使用分析

| 操作 | Gas 使用量 | 说明 |
|------|-----------|------|
| 部署 BigBank | ~800,000 | 包含继承和修饰符 |
| 部署 Admin | ~400,000 | 简单管理合约 |
| 用户存款 | ~50,000 | 基础存款操作 |
| 管理员转移 | ~30,000 | 状态变更操作 |
| Admin 提取 | ~60,000 | 跨合约调用 |

## 🌐 网络支持

- ✅ **Anvil** (本地测试网络)
- ✅ **Sepolia** (公共测试网)
- ✅ **Goerli** (公共测试网)
- ✅ **Tryether** (在线测试环境)

## 🤝 贡献指南

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启 Pull Request

## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

## 🔗 相关链接

- [Foundry 文档](https://book.getfoundry.sh/)
- [Solidity 文档](https://docs.soliditylang.org/)
- [OpenZeppelin](https://docs.openzeppelin.com/)

## ❓ 常见问题

### Q: 为什么在 Anvil 能查到余额，但在 Tryether 不行？
A: Anvil 和 Tryether 是不同的网络环境，有独立的状态和账户系统。需要在对应网络重新部署合约。

### Q: 如何获取测试网络的 ETH？
A: 
- **Sepolia**: 使用 [Sepolia Faucet](https://sepoliafaucet.com/)
- **Goerli**: 使用 [Goerli Faucet](https://goerlifaucet.com/)
- **Tryether**: 在平台内申请测试币

### Q: 部署失败怎么办？
A: 
1. 检查网络连接
2. 确认账户有足够的 ETH 支付 Gas
3. 验证私钥格式正确
4. 查看错误日志定位问题

---

**Made with ❤️ for Ethereum development**