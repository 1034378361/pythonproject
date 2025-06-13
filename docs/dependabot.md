# 依赖自动更新

本项目使用GitHub Dependabot自动检测并更新依赖，确保项目使用的库和工具保持最新和安全。

## Dependabot配置

Dependabot配置位于`.github/dependabot.yml`文件中，当前配置包括：

### Python依赖更新
- **更新频率**：每周一上午9点（中国时间）
- **PR数量限制**：最多同时打开10个PR
- **版本策略**：仅推荐次要版本和补丁版本更新，忽略可能包含破坏性更改的主要版本
- **依赖分组**：
  - 开发依赖（pytest、black、mypy等）分组更新
  - 文档依赖（sphinx相关）分组更新

### GitHub Actions更新
- **更新频率**：每周一
- **PR数量限制**：最多5个

### Docker镜像更新
- **更新频率**：每月
- **PR数量限制**：最多5个

## 使用方式

### 查看更新
当有新的依赖更新时，Dependabot会自动在GitHub仓库创建PR。每个PR包含：
- 具体更改内容
- 更新的版本号
- 依赖的变更日志链接
- 自动运行的测试结果

### 处理更新PR
1. **审查更改**：检查PR内容，确保更新不会引入问题
2. **等待CI结果**：确保自动化测试通过
3. **合并PR**：如果没有问题，合并PR更新依赖

### 自定义配置

如需调整Dependabot行为，可以修改`.github/dependabot.yml`文件：

- 调整更新频率（daily/weekly/monthly）
- 修改时区或更新时间
- 添加/移除依赖分组
- 忽略特定依赖或版本

## 安全更新

当依赖中发现安全漏洞时，Dependabot会创建高优先级PR，建议及时审查并合并这些更新。

## 延伸阅读
- [Dependabot文档](https://docs.github.com/zh/code-security/dependabot/dependabot-version-updates/about-dependabot-version-updates)
