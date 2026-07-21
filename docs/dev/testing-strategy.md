# 测试策略

## 当前状态

项目包含 `PauseGuardTests` 和 `PauseGuardUITests` targets。XCUITest target 与测试源码属于合法项目内容，可按需求保留、创建或修改，也可由人工执行。Agent 禁止自行执行 XCUITest、脚本化模拟器交互、MCP 驱动点击或其他 UI 自动化；UI 最终通过人工视觉验收。

## 原则

- 测试高风险行为和边界，而不是追求数字。
- 测试必须可重复，不依赖真实网络、墙钟时间、随机值或外部账号。
- 修复 bug 时，优先先证明测试能复现旧行为，再验证修复。
- 测试名称应表达被测对象、场景和预期结果。

## 分层

| 类型 | 位置 | 适用范围 |
|---|---|---|
| 单元测试 | `PauseGuardTests/` | Domain 规则、状态转换、解析、ViewModel |
| 集成测试 | `PauseGuardTests/` | Repository 与受控内存存储、组件协作 |
| 人工 UI 验收 | 人工执行 | 视觉、交互、适配、Dynamic Type 与关键用户路径 |

优先保持大量快速单元测试和少量有价值的集成测试。XCUITest 仅在覆盖关键交互具有明确价值时维护；Agent 不自行运行，人工可按团队流程执行。

## Swift Testing

新单元测试优先使用 `Testing`：

```swift
import Testing
@testable import PauseGuard

struct ExampleTests {
    @Test
    func subject_whenCondition_hasExpectedResult() {
        #expect(true)
    }
}
```

异步测试使用 `async throws`。通过 fake clock、stub repository 或临时内存存储控制外部条件。

## 人工 UI 验收

- UI 变更由人工在代表性设备尺寸上检查。XCUITest 可以作为补充证据，但 Agent 不自行执行，且不能代替人工视觉验收。
- 验证深浅色、Dynamic Type、本地化、安全区、键盘、权限拒绝、loading、empty 和 error 状态。
- 对文本和动态内容的严格宽高约束逐项确认；可疑固定约束必须在 PR 前获得人工确认。
- Simulator、预览和截图可辅助实现与说明，但不能替代人工验收结论。
- UI PR 必须记录人工 `PASS`；未确认时 PR 门禁暂停。

## 验证顺序

1. 运行最窄的相关测试。
2. 运行 `PauseGuardTests`。
3. UI 变化由人工完成视觉验收并记录 `PASS`。
4. 发布前执行完整单元/集成测试与 Release 构建。

若因模拟器、签名或工具不可用未运行某项，明确记录为验证缺口，不能写成通过。
