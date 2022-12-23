# Admin Abuse Mod

## Usage

首先需要把自己或其他玩家设置成管理员.

1: 打开`~/Titanfall2/R2Northstar/mods/Karma.Abuse/mod.json`

2: 修改 "grant_admin" 变量的值为你或他人的UID
- 你可以在控制台输入 `sv_cheats 1; print(GetPlayerArray()[0].GetUID())` 来查看自己的uid，北极星cn则在左上角自动显示uid
- 添加多个管理员使用逗号分隔，务必不要数字之外的符号如空格.
- Ex : `DefaultValue: "12032103911321,10293021931,10920329139"`

3: 可选项：修改欢迎消息及其颜色，欢迎消息将在每局开始时展示.

4: 可选项：启动chathook，在 ns_startup_args_dedi.txt 写上 `-enablechathooks`
- 开启chathook可以在聊天框输入指令，格式 : `!控制台指令`

## Commands
作为管理员，在客户端控制台输入指令即可使用mod.

这个mod有非常多新添加的指令. 这里有一些例子:
- `gift predator all smart` 将会给所有玩家一个开启智慧核心的猎杀者机炮
- `gift plasma imc instant` 将会给所有IMC队伍的玩家一把配有"即刻射击"配件的电浆磁轨炮(原版游戏未实装配件)
- `rpwn all spawn titan` 以泰坦状态，在可用出生点处复活所有死亡玩家
- `freeze/unfreeze someone` freeze将玩家冻结在原地(不可移动)，unfreeze解冻

**下为目前的指令列表** (v1.2.4; Last updated: 14/3/2022)
- 通用参数：someone: 某个玩家的名字, imc: 所有imc队伍的玩家, militia: 所有反抗军队伍的玩家, all: 服务器内所有玩家
- 该mod在没有输全参数时会自动补充最相近的参数，如武器ID为mp_weapon_sniper 通过 mp_weapon_sni 即可获取。 可通过玩家的序号获取玩家名字， 序号将在玩家名前显示，如 [0]player
- `slay someone/imc/militia/all` // 杀死指定玩家
- `switchteam/st someone/imc/militia/all` // 切换指定玩家的队伍
- `respawn/rpwn someone/imc/militia/all someone/spawn/BLANK pilot/titan/BLANK`// 复活指定玩家
- 参数1: someone: 在某人位置复活, spawn: 在出生点复活, BLANK: 原地复活
- 参数2: pilot: 作为铁驭复活，titan: 作为泰坦复活, BLANK: 继承死前职业(铁驭或泰坦)复活
- `gift <weaponId> <someone/imc/militia/all> <mods1> <mods2> <mods3>` // 给予指定玩家一把武器
- 参数1: weaponId: 武器的文件名
- 参数2: mods 武器的配件(可以最多四个)
- `gift <weaponId> <someone/imc/militia/all>` // 强制给予指定玩家一把武器，可以是原版里没有的、通过其他mod加进来的武器，但注意不能给予配件且输错武器文件名服务器将会崩溃
- `rearm someone/imc/militia/all` // 立刻补满指定玩家的技能
- `fly someone/imc/militia/all` // 使指定玩家可以穿墙
- `titanfall/tf <someone/imc/militia/all>`// 为指定玩家降落泰坦
- `teleport <someone/imc/militia/all> <someone/crosshair>` // 传送指定玩家
- 参数: someone: 至某人位置， crosshair: 至你的准星处
- `removeweapon/rw someone/team/all main weapons`// 移除指定玩家的全部主武器(即不移除技能)
- `freeze someone/team/all`// 冻结指定玩家
- `unfreeze someone/team/all`// 解冻指定玩家
- `hp/health someone/team/all <value>` // 设置指定玩家的最高生命，铁驭默认100，泰坦一格血2500
- `announce someone/team/all <word1> <word2> <word3>` // 为指定玩家播送消息
- 参数: word: 消息单词
- `getteam someone` // 获取指定玩家的队伍，打印在聊天框
- `shuffleteam/shuffleteams` // 为玩家分队，这个有自动化的mod叫teamshuffle
- `v/vanish someone/imc/militia/all` // 使指定玩家变得完全隐身
- `uv/unvanish someone/imc/militia/all` // 解除指定玩家的完全隐身
- `sonar someone/imc/militia/all <duration>` // 使指定玩家被脉冲高亮
- 参数: duration: 持续时间
- `prop someone/imc/militia/all <duration> <modelpath>` // 在指定玩家处摆放一个指定模型
- 参数: duration: 持续时间，modelpath: 模型在vpk里的路径及其文件名
- `unprop someone/imc/militia/all` // 立刻销毁在指定玩家处摆放的模型(通常设定的持续时间结束后自动销毁)
- `getmod/gm/getmods <weaponId>` // 获取某个武器的配件列表(打印在服务器控制台，客户端控制台看不到)
- 参数: weaponId: 武器的文件名
- `fgetmod/fgm/fgetmods <weaponId>` // 强制获取某个武器的配件列表，强制获取即尝试获取原版游戏不存在的、由其他mod加进来的新武器配件列表，注意武器文件名输错会导致服务器崩溃
- `bubbleshield/bs someone/imc/militia/all <duration>` // 在指定玩家处创建圆顶护罩，该护罩为固体，不可穿过
- 参数: duration: 持续时间
- `unbubbleshield/unbs someone/imc/militia/all` // 立刻销毁在指定玩家处的圆顶护罩
- `airaccel/aa someone/imc/militia/all <value> [save]` // 设置指定玩家的空中加速值
- 参数1: value: 空中加速的值
- 参数2: save: 复活后是否保留空中加速

## Additional Information
If you require any assistance, or encounter any bugs in this mod, message me on the [Northstar Discord Server](https://discord.gg/northstar) (x3Karma#6984)

Link to the [GitHub Repo](https://github.com/x3Karma/Admin-Abuse-Mod).
