# 如何创建 Pull Request

## 方法 1: 使用 GitHub CLI（推荐）

### 1. 安装 GitHub CLI
```bash
# Windows (使用 winget)
winget install GitHub.cli

# 或访问 https://cli.github.com/ 下载安装
```

### 2. 登录 GitHub
```bash
gh auth login
```

### 3. 创建 PR
```bash
# 确保在 main 分支
git checkout main

# 创建 PR（从 develop 到 main）
gh pr create --base main --head develop --title "Phase 6: 数据增强（第一阶段）" --body-file PULL_REQUEST.md
```

### 4. 查看 PR
```bash
gh pr view
```

---

## 方法 2: 使用 GitHub 网页界面

### 1. 推送 develop 分支到远程
```bash
git push origin develop
```

### 2. 访问 GitHub 仓库
打开浏览器访问：`https://github.com/你的用户名/ZenCalendar`

### 3. 创建 PR
1. 点击 "Pull requests" 标签
2. 点击 "New pull request" 按钮
3. 选择分支：
   - base: `main`
   - compare: `develop`
4. 点击 "Create pull request"
5. 填写 PR 信息：
   - 标题：`Phase 6: 数据增强（第一阶段）`
   - 描述：复制 `PULL_REQUEST.md` 的内容
6. 点击 "Create pull request" 完成

### 4. 添加审查者（可选）
1. 在 PR 页面右侧点击 "Reviewers"
2. 选择需要审查的人员
3. 点击 "Request review"

---

## 方法 3: 使用 Git 命令行（手动）

### 1. 推送 develop 分支
```bash
git push origin develop
```

### 2. 在 GitHub 上创建 PR
访问以下 URL（替换你的用户名和仓库名）：
```
https://github.com/你的用户名/ZenCalendar/compare/main...develop
```

这会自动打开创建 PR 的页面。

---

## PR 创建后的工作流程

### 1. 等待审查
- 审查者会查看代码变更
- 可能会提出修改建议
- 在 PR 页面进行讨论

### 2. 根据反馈修改代码
```bash
# 切换到 develop 分支
git checkout develop

# 进行修改...

# 提交修改
git add .
git commit -m "根据审查反馈修改代码"

# 推送到远程（PR 会自动更新）
git push origin develop
```

### 3. 合并 PR
当审查通过后，有以下合并选项：

#### 选项 1: Merge commit（保留所有提交历史）
```bash
# 在 GitHub 上点击 "Merge pull request"
# 或使用 CLI
gh pr merge --merge
```

#### 选项 2: Squash and merge（压缩为单个提交）
```bash
# 在 GitHub 上选择 "Squash and merge"
# 或使用 CLI
gh pr merge --squash
```

#### 选项 3: Rebase and merge（变基合并）
```bash
# 在 GitHub 上选择 "Rebase and merge"
# 或使用 CLI
gh pr merge --rebase
```

### 4. 合并后清理
```bash
# 切换回 main 分支
git checkout main

# 拉取最新代码
git pull origin main

# 删除本地 develop 分支（可选）
git branch -d develop

# 删除远程 develop 分支（可选）
git push origin --delete develop
```

---

## 当前项目状态

### 分支情况
```
main (v1.0)
  └── develop (Phase 6 开发中)
      ├── 572dc45 - Phase 6.1: 实现数据模型和导入导出服务
      ├── fd0bb29 - Phase 6.2: 实现分类仓库和备份服务
      └── 85024ee - 添加 Phase 6 开发进度文档
```

### 准备创建 PR
```bash
# 1. 确保所有更改已提交
git status

# 2. 推送 develop 分支到远程
git push origin develop

# 3. 使用上述任一方法创建 PR
```

---

## PR 审查清单

### 代码质量
- [ ] 代码符合项目规范
- [ ] 有适当的注释和文档
- [ ] 没有明显的 bug
- [ ] 错误处理完善

### 功能完整性
- [ ] 实现了计划的功能
- [ ] 测试覆盖充分
- [ ] 向后兼容

### 性能和安全
- [ ] 没有性能问题
- [ ] 没有安全漏洞
- [ ] 资源使用合理

### 文档
- [ ] 更新了相关文档
- [ ] 添加了必要的注释
- [ ] README 保持最新

---

## 常见问题

### Q: PR 创建后可以继续提交吗？
A: 可以。在 develop 分支上的新提交会自动添加到 PR 中。

### Q: 如何撤销 PR？
A: 在 PR 页面点击 "Close pull request"，或使用 `gh pr close`。

### Q: 合并后 develop 分支怎么办？
A: 可以删除，也可以保留继续开发。建议删除后重新从 main 创建新的 develop 分支。

### Q: 如何解决合并冲突？
```bash
# 1. 切换到 develop 分支
git checkout develop

# 2. 合并 main 分支
git merge main

# 3. 解决冲突...

# 4. 提交合并
git add .
git commit -m "解决合并冲突"

# 5. 推送
git push origin develop
```

---

## 推荐的 PR 工作流

1. **创建功能分支**
   ```bash
   git checkout -b feature/new-feature
   ```

2. **开发和提交**
   ```bash
   git add .
   git commit -m "实现新功能"
   ```

3. **推送到远程**
   ```bash
   git push origin feature/new-feature
   ```

4. **创建 PR**
   ```bash
   gh pr create --base main --head feature/new-feature
   ```

5. **审查和修改**
   - 根据反馈修改代码
   - 推送更新

6. **合并 PR**
   ```bash
   gh pr merge --squash
   ```

7. **清理分支**
   ```bash
   git checkout main
   git pull
   git branch -d feature/new-feature
   ```

---

## 下一步

现在你可以：

1. **推送 develop 分支**
   ```bash
   git push origin develop
   ```

2. **创建 PR**（选择上述任一方法）

3. **等待审查和合并**

4. **继续开发 Phase 6 的 UI 部分**
