local M = {}

local langs_mt = {}
langs_mt.__index = langs_mt
function langs_mt:list(field)
  local deduplist = {}
  local result = {}
  -- deduplication
  for _, info in pairs(self) do
    if type(info[field]) == 'string' then
      deduplist[info[field]] = true
    end
  end
  for name, _ in pairs(deduplist) do
    table.insert(result, name)
  end
  return result
end

M.langs = setmetatable({
  bash = { ft = 'sh', lsp_server = 'bashls', dap = 'bash' },
  c = { ts = 'c', ft = 'c', lsp_server = 'clangd', dap = 'codelldb' },
  cpp = { ts = 'cpp', ft = 'cpp', lsp_server = 'clangd', dap = 'codelldb' },
  lua = { ts = 'lua', ft = 'lua', lsp_server = 'sumneko_lua' },
  make = { ts = 'make', ft = 'make' },
  python = { ts = 'python', ft = 'python', lsp_server = 'pylsp', dap = 'python' },
  vim = { ts = 'vim', ft = 'vim', lsp_server = 'vimls' },
}, langs_mt)

M.borders = {
  rounded = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
  single = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
  double = { '═', '║', '═', '║', '╔', '╗', '╝', '╚' },
  double_header = { '═', '│', '─', '│', '╒', '╕', '┘', '└' },
  double_bottom = { '─', '│', '═', '│', '┌', '┐', '╛', '╘' },
  double_horizontal = { '═', '│', '═', '│', '╒', '╕', '╛', '╘' },
  double_left = { '─', '│', '─', '│', '╓', '┐', '┘', '╙' },
  double_right = { '─', '│', '─', '│', '┌', '╖', '╜', '└' },
  double_vertical = { '─', '│', '─', '│', '╓', '╖', '╜', '╙' },
  vintage = { '-', '|', '-', '|', '+', '+', '+', '+' },
  rounded_clc = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
  single_clc = { '┌', '─', '┐', '│', '┘', '─', '└', '│' },
  double_clc = { '╔', '═', '╗', '║', '╝', '═', '╚', '║' },
  double_header_clc = { '╒', '═', '╕', '│', '┘', '─', '└', '│' },
  double_bottom_clc = { '┌', '─', '┐', '│', '╛', '═', '╘', '│' },
  double_horizontal_clc = { '╒', '═', '╕', '│', '╛', '═', '╘', '│' },
  double_left_clc = { '╓', '─', '┐', '│', '┘', '─', '╙', '│' },
  double_right_clc = { '┌', '─', '╖', '│', '╜', '─', '└', '│' },
  double_vertical_clc = { '╓', '─', '╖', '│', '╜', '─', '╙', '│' },
  vintage_clc = { '+', '-', '+', '|', '+', '-', '+', '|' }
}

M.icons = {
  Array = ' ',
  Boolean = ' ',
  Calculator = ' ',
  Class = ' ',
  Collapsed = ' ',
  Color = ' ',
  Constant = ' ',
  Constructor = ' ',
  Copilot = ' ',
  DiagnosticSignError = ' ',
  DiagnosticSignHint = ' ',
  DiagnosticSignInfo = ' ',
  DiagnosticSignWarn = ' ',
  Enum = ' ',
  EnumMember = ' ',
  Event = ' ',
  Field = ' ',
  File = ' ',
  Folder = ' ',
  Function = ' ',
  Interface = ' ',
  Keyword = ' ',
  Type = ' ',
  Method = ' ',
  Module = ' ',
  Namespace = ' ',
  Number = ' ',
  Object = ' ',
  Operator = ' ',
  Package = ' ',
  Property = ' ',
  Reference = ' ',
  Regex = ' ',
  Repeat = ' ',
  Snippet = ' ',
  String = ' ',
  Specifier = ' ',
  Statement = ' ',
  Struct = ' ',
  Terminal = ' ',
  Ellipsis = '… ',
  Text = ' ',
  TypeParameter = ' ',
  Unit = '塞 ',
  Value = ' ',
  Variable = ' ',
}

-- Original source: http://patorjk.com/blog/software/
M.ascii_art = {
  {
    [[███╗  ██╗ ███████╗  █████╗  ██╗   ██╗ ██╗ ███╗   ███╗]],
    [[████╗ ██║ ██╔════╝ ██╔══██╗ ██║   ██║ ██║ ████╗ ████║]],
    [[██╔██╗██║ █████╗   ██║  ██║ ╚██╗ ██╔╝ ██║ ██╔████╔██║]],
    [[██║╚████║ ██╔══╝   ██║  ██║  ╚████╔╝  ██║ ██║╚██╔╝██║]],
    [[██║ ╚███║ ███████╗ ╚█████╔╝   ╚██╔╝   ██║ ██║ ╚═╝ ██║]],
    [[╚═╝  ╚══╝ ╚══════╝  ╚════╝     ╚═╝    ╚═╝ ╚═╝     ╚═╝]]
  },
  {
    [[┏━┓┏━━┳━━┳┓┏┳┳┓┏┓]],
    [[┃┏┓┫┃━┫┏┓┃┗┛┣┫┗┛┃]],
    [[┃┃┃┃┃━┫┗┛┣┓┏┫┃┃┃┃]],
    [[┗┛┗┻━━┻━━┛┗┛┗┻┻┻┛]]
  },
  {
    [[╔═╗╔══╦══╦╗╔╦╦╗╔╗]],
    [[║╔╗╣║═╣╔╗║╚╝╠╣╚╝║]],
    [[║║║║║═╣╚╝╠╗╔╣║║║║]],
    [[╚╝╚╩══╩══╝╚╝╚╩╩╩╝]]
  },
  {
    [[╋╋╋╋╋╋╋╋╋╋╋┏┓]],
    [[┏━┳┳━┳━┳━┳━╋╋━━┓]],
    [[┃┃┃┃┻┫╋┣┓┃┏┫┃┃┃┃]],
    [[┗┻━┻━┻━┛┗━┛┗┻┻┻┛]]
  },
  {
    [[╬╬╬╬╬╬╬╬╬╬╬╔╗   ]],
    [[╔═╦╦═╦═╦═╦═╬╬══╗]],
    [[║║║║╩╣╬╠╗║╔╣║║║║]],
    [[╚╩═╩═╩═╝╚═╝╚╩╩╩╝]]
  },
  {
    [[-. . --- ...- .. --]]
  },
  {
    [[116    105    117    126    111    115]],
  },
  {
    [[4E    45    4F    56    49    4D]],
  },
  {
    [[0    1    1    0    1    1    1    0]],
    [[0    1    1    0    0    1    0    1]],
    [[0    1    1    0    1    1    1    1]],
    [[0    1    1    1    0    1    1    0]],
    [[0    1    1    0    1    0    0    1]],
    [[0    1    1    0    1    1    0    1]],
  },
  {
    [[╭╮╭┬─╮╭─╮┬  ┬┬╭┬╮]],
    [[│││├┤ │ │╰┐┌╯││││]],
    [[╯╰╯╰─╯╰─╯ ╰╯ ┴┴ ┴]]
  },
  {
    [[┌┐┌┬─┐┌─┐┬  ┬┬┌┬┐]],
    [[│││├┤ │ │└┐┌┘││││]],
    [[┘└┘└─┘└─┘ └┘ ┴┴ ┴]]
  },
  {
    [[╔╗╔╦═╗╔═╗╦  ╦╦╔╦╗]],
    [[║║║╠╣ ║ ║╚╗╔╝║║║║]],
    [[╝╚╝╚═╝╚═╝ ╚╝ ╩╩ ╩]]
  },
  {
    [[__   _ ______  _____  _    _ _____ _______]],
    [[| \  | |_____ |     |  \  /    |   |  |  |]],
    [[|  \_| |_____ |_____|   \/   __|__ |  |  |]],
  },
  {
    [[       _   _         ___      ]],
    [[|\ |  |_  / \  \  /   |   |\/|]],
    [[| \|  |_  \_/   \/   _|_  |  |]]
  },
  {
    [[ _      ____  ___   _      _   _    ]],
    [[| |\ | | |_  / / \ \ \  / | | | |\/|]],
    [[|_| \| |_|__ \_\_/  \_\/  |_| |_|  |]]
  },
  {
    [[ ______                            _         ]],
    [[|  ___ \                          (_)        ]],
    [[| |   | |   ____    ___    _   _   _   ____  ]],
    [[| |   | |  / _  )  / _ \  | | | | | | |    \ ]],
    [[| |   | | ( (/ /  | |_| |  \ V /  | | | | | |]],
    [[|_|   |_|  \____)  \___/    \_/   |_| |_|_|_|]]
  },
  {
    [[                                _             ]],
    [[ _ __     ___    ___   __   __ (_)  _ __ ___  ]],
    [[| '_ \   / _ \  / _ \  \ \ / / | | | '_ ` _ \ ]],
    [[| | | | |  __/ | (_) |  \ V /  | | | | | | | |]],
    [[|_| |_|  \___|  \___/    \_/   |_| |_| |_| |_|]]
  },
  {
    [[                               _           ]],
    [[   ____   ___   ____  _   _   (_) ____ ___ ]],
    [[  / __ \ / _ \ / __ \| | / / / / / __ `__ \]],
    [[ / / / //  __// /_/ /| |/ / / / / / / / / /]],
    [[/_/ /_/ \___/ \____/ |___/ /_/ /_/ /_/ /_/ ]]
  },
  {
    [[                               __                ]],
    [[  ___     ___    ___   __  __ /\_\    ___ ___    ]],
    [[ / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ]],
    [[/\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
    [[\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
    [[ \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]]
  },
  {
    [[     ___           ___           ___           ___                       ___     ]],
    [[    /\__\         /\  \         /\  \         /\__\          ___        /\__\    ]],
    [[   /::|  |       /::\  \       /::\  \       /:/  /         /\  \      /::|  |   ]],
    [[  /:|:|  |      /:/\:\  \     /:/\:\  \     /:/  /          \:\  \    /:|:|  |   ]],
    [[ /:/|:|  |__   /::\‾\:\  \   /:/  \:\  \   /:/__/  ___      /::\__\  /:/|:|__|__ ]],
    [[/:/ |:| /\__\ /:/\:\ \:\__\ /:/__/ \:\__\  |:|  | /\__\  __/:/\/__/ /:/ |::::\__\]],
    [[\/__|:|/:/  / \:\‾\:\ \/__/ \:\  \ /:/  /  |:|  |/:/  / /\/:/  /    \/__/‾‾/:/  /]],
    [[    |:/:/  /   \:\ \:\__\    \:\  /:/  /   |:|__/:/  /  \::/__/           /:/  / ]],
    [[    |::/  /     \:\ \/__/     \:\/:/  /     \::::/__/    \:\__\          /:/  /  ]],
    [[    /:/  /       \:\__\        \::/  /       ‾‾‾‾         \/__/         /:/  /   ]],
    [[    \/__/         \/__/         \/__/                                   \/__/    ]]
  },
  {
    [[     ___           ___           ___                                     ___     ]],
    [[    /\  \         /\__\         /\  \          ___                      /\  \    ]],
    [[    \:\  \       /:/ _/_       /::\  \        /\  \        ___         |::\  \   ]],
    [[     \:\  \     /:/ /\__\     /:/\:\  \       \:\  \      /\__\        |:|:\  \  ]],
    [[ _____\:\  \   /:/ /:/ _/_   /:/  \:\  \       \:\  \    /:/__/      __|:|\:\  \ ]],
    [[/::::::::\__\ /:/_/:/ /\__\ /:/__/ \:\__\  ___  \:\__\  /::\  \     /::::|_\:\__\]],
    [[\:\‾‾\‾‾\/__/ \:\/:/ /:/  / \:\  \ /:/  / /\  \ |:|  |  \/\:\  \__  \:\‾‾\  \/__/]],
    [[ \:\  \        \::/_/:/  /   \:\  /:/  /  \:\  \|:|  |   ‾‾\:\/\__\  \:\  \      ]],
    [[  \:\  \        \:\/:/  /     \:\/:/  /    \:\__|:|__|      \::/  /   \:\  \     ]],
    [[   \:\__\        \::/  /       \::/  /      \::::/__/       /:/  /     \:\__\    ]],
    [[    \/__/         \/__/         \/__/        ‾‾‾‾           \/__/       \/__/    ]]
  },
  {
    [[     ___           ___           ___                                    ___     ]],
    [[    /__/\         /  /\         /  /\          ___        ___          /__/\    ]],
    [[    \  \:\       /  /:/_       /  /::\        /__/\      /  /\        |  |::\   ]],
    [[     \  \:\     /  /:/ /\     /  /:/\:\       \  \:\    /  /:/        |  |:|:\  ]],
    [[ _____\__\:\   /  /:/ /:/_   /  /:/  \:\       \  \:\  /__/::\      __|__|:|\:\ ]],
    [[/__/::::::::\ /__/:/ /:/ /\ /__/:/ \__\:\  ___  \__\:\ \__\/\:\__  /__/::::| \:\]],
    [[\  \:\‾‾\‾‾\/ \  \:\/:/ /:/ \  \:\ /  /:/ /__/\ |  |:|    \  \:\/\ \  \:\‾‾\__\/]],
    [[ \  \:\  ‾‾‾   \  \::/ /:/   \  \:\  /:/  \  \:\|  |:|     \__\::/  \  \:\      ]],
    [[  \  \:\        \  \:\/:/     \  \:\/:/    \  \:\__|:|     /__/:/    \  \:\     ]],
    [[   \  \:\        \  \::/       \  \::/      \__\::::/      \__\/      \  \:\    ]],
    [[    \__\/         \__\/         \__\/           ‾‾‾‾                   \__\/    ]]
  },
  {
    [[     ___           ___           ___                                      ___     ]],
    [[    /  /\         /  /\         /  /\          ___            ___        /  /\    ]],
    [[   /  /::|       /  /::\       /  /::\        /  /\          /__/\      /  /::|   ]],
    [[  /  /:|:|      /  /:/\:\     /  /:/\:\      /  /:/          \__\:\    /  /:|:|   ]],
    [[ /  /:/|:|__   /  /::\ \:\   /  /:/  \:\    /  /:/           /  /::\  /  /:/|:|__ ]],
    [[/__/:/ |:| /\ /__/:/\:\ \:\ /__/:/ \__\:\  /__/:/  ___    __/  /:/\/ /__/:/_|::::\]],
    [[\__\/  |:|/:/ \  \:\ \:\_\/ \  \:\ /  /:/  |  |:| /  /\  /__/\/:/‾‾  \__\/  /‾‾/:/]],
    [[    |  |:/:/   \  \:\ \:\    \  \:\  /:/   |  |:|/  /:/  \  \::/           /  /:/ ]],
    [[    |__|::/     \  \:\_\/     \  \:\/:/    |__|:|__/:/    \  \:\          /  /:/  ]],
    [[    /__/:/       \  \:\        \  \::/      \__\::::/      \__\/         /__/:/   ]],
    [[    \__\/         \__\/         \__\/           ‾‾‾‾                     \__\/    ]]
  },
  {
    [[ /$$$$$$$   /$$$$$$   /$$$$$$  /$$    /$$ /$$ /$$$$$$/$$$$ ]],
    [[| $$__  $$ /$$__  $$ /$$__  $$|  $$  /$$/| $$| $$_  $$_  $$]],
    [[| $$  \ $$| $$$$$$$$| $$  \ $$ \  $$/$$/ | $$| $$ \ $$ \ $$]],
    [[| $$  | $$| $$_____/| $$  | $$  \  $$$/  | $$| $$ | $$ | $$]],
    [[| $$  | $$|  $$$$$$$|  $$$$$$/   \  $/   | $$| $$ | $$ | $$]],
    [[|__/  |__/ \_______/ \______/     \_/    |__/|__/ |__/ |__/]]
  },
  {
    [[ __   __     ______     ______     __   __   __     __    __   ]],
    [[/\ "-.\ \   /\  ___\   /\  __ \   /\ \ / /  /\ \   /\ "-./  \  ]],
    [[\ \ \-.  \  \ \  __\   \ \ \/\ \  \ \ \'/   \ \ \  \ \ \-./\ \ ]],
    [[ \ \_\\"\_\  \ \_____\  \ \_____\  \ \__|    \ \_\  \ \_\ \ \_\]],
    [[  \/_/ \/_/   \/_____/   \/_____/   \/_/      \/_/   \/_/  \/_/]]
  },
  {
    [[ ___   __       ______       ______       __   __      ________      ___ __ __     ]],
    [[/__/\ /__/\    /_____/\     /_____/\     /_/\ /_/\    /_______/\    /__//_//_/\    ]],
    [[\::\_\\  \ \   \::::_\/_    \:::_ \ \    \:\ \\ \ \   \__.::._\/    \::\| \| \ \   ]],
    [[ \:. `-\  \ \   \:\/___/\    \:\ \ \ \    \:\ \\ \ \     \::\ \      \:.      \ \  ]],
    [[  \:. _    \ \   \::___\/_    \:\ \ \ \    \:\_/.:\ \    _\::\ \__    \:.\-/\  \ \ ]],
    [[   \. \`-\  \ \   \:\____/\    \:\_\ \ \    \ ..::/ /   /__\::\__/\    \. \  \  \ \]],
    [[    \__\/ \__\/    \_____\/     \_____\/     \___/_(    \________\/     \__\/ \__\/]]
  },
  {
    [[ _  _  ____  _____  _  _  ____  __  __ ]],
    [[( \( )( ___)(  _  )( \/ )(_  _)(  \/  )]],
    [[ )  (  )__)  )(_)(  \  /  _)(_  )    ( ]],
    [[(_)\_)(____)(_____)  \/  (____)(_/\/\_)]]
  },
  {
    [[  _   _     U _____ u    U  ___ u  __     __                   __  __  ]],
    [[ | \ |"|    \| ___"|/     \/"_ \/  \ \   /"/u       ___      U|' \/ '|u]],
    [[<|  \| |>    |  _|"       | | | |   \ \ / //       |_"_|     \| |\/| |/]],
    [[ |\  |u    | |___   .-,_| |_| |   /\ V /_,-.      | |       | |  | |   ]],
    [[ |_| \_|     |_____|   \_)-\___/   U  \_/-(_/     U/| |\u     |_|  |_| ]],
    [[ ||   \\,-.  <<   >>        \\       //        .-,_|___|_,-. <<,-,,-.  ]],
    [[ (_")  (_/  (__) (__)      (__)     (__)        \_)-' '-(_/   (./  \.) ]]
  },
  {
    [[    )            )             (        *    ]],
    [[ ( /(         ( /(             )\ )   (  `   ]],
    [[ )\())  (     )\())   (   (   (()/(   )\))(  ]],
    [[((_)\   )\   ((_)\    )\  )\   /(_)) ((_)()\ ]],
    [[ _((_) ((_)    ((_)  ((_)((_) (_))   (_()((_)]],
    [[| \| | | __|  / _ \  \ \ / /  |_ _|  |  \/  |]],
    [[| .` | | _|  | (_) |  \ V /    | |   | |\/| |]],
    [[|_|\_| |___|  \___/    \_/    |___|  |_|  |_|]]
  },
  {
    [[    )                                    ]],
    [[ ( /(                                    ]],
    [[ )\())    (            )     (       )   ]],
    [[((_)\    ))\    (     /((    )\     (    ]],
    [[ _((_)  /((_)   )\   (_))\  ((_)    )\  ']],
    [[| \| | (_))    ((_)  _)((_)  (_)  _((_)) ]],
    [[| .` | / -_)  / _ \  \ V /   | | | '  \()]],
    [[|_|\_| \___|  \___/   \_/    |_| |_|_|_| ]]
  },
  {
    [[\\\  ///              .-.     wWw    wWw    wW  Ww  \\\    ///]],
    [[((O)(O))    wWw     c(O_O)c   (O)    (O)    (O)(O)  ((O)  (O))]],
    [[ | \ ||     (O)_   ,'.---.`,  ( \    / )     (..)    | \  / | ]],
    [[ ||\\||    .' __) / /|_|_|\ \  \ \  / /       ||     ||\\//|| ]],
    [[ || \ |   (  _)   | \_____/ |  /  \/  \      _||_    || \/ || ]],
    [[ ||  ||    `.__)  '. `---' .`  \ `--' /     (_/\_)   ||    || ]],
    [[(_/  \_)            `-...-'     `-..-'              (_/    \_)]]
  },
  {
    [[     .-') _     ('-.                      (`-.              _   .-')    ]],
    [[    ( OO ) )  _(  OO)                   _(OO  )_           ( '.( OO )_  ]],
    [[,--./ ,--,'  (,------.  .-'),-----. ,--(_/   ,. \  ,-.-')   ,--.   ,--.)]],
    [[|   \ |  |\   |  .---' ( OO'  .-.  '\   \   /(__/  |  |OO)  |   `.'   | ]],
    [[|    \|  | )  |  |     /   |  | |  | \   \ /   /   |  |  \  |         | ]],
    [[|  .     |/  (|  '--.  \_) |  |\|  |  \   '   /,   |  |(_/  |  |'.'|  | ]],
    [[|  |\    |    |  .--'    \ |  | |  |   \     /__) ,|  |_.'  |  |   |  | ]],
    [[|  | \   |    |  `---.    `'  '-'  '    \   /    (_|  |     |  |   |  | ]],
    [[`--'  `--'    `------'      `-----'      `-'       `--'     `--'   `--' ]]
  },
  {
    [[  _  _      ___      ___    __   __    ___    __  __  O         ]],
    [[ | \| |    | __|    / _ \   \ \ / /   |_ _|  |  \/  |   o       ]],
    [[ | .` |    | _|    | (_) |   \ V /     | |   | |\/| |  ___      ]],
    [[ |_|\_|    |___|    \___/    _\_/_    |___|  |_|__|_|  |o|____  ]],
    [[_|"""""| _|"""""| _|"""""| _|"""""| _|"""""| _|"""""| _|"""""") ]],
    [["`-0-0-' "`-0-0-' "`-0-0-' "`-0-0-' "`-0-0-' "`-0-0-' "`-0-0---\]]
  },
  {
    [[        /\ \     _      /\ \           /\ \     /\ \    _ / /\        /\ \        /\_\/\_\ _  ]],
    [[       /  \ \   /\_\   /  \ \         /  \ \    \ \ \  /_/ / /        \ \ \      / / / / //\_\]],
    [[      / /\ \ \_/ / /  / /\ \ \       / /\ \ \    \ \ \ \___\/         /\ \_\    /\ \/ \ \/ / /]],
    [[     / / /\ \___/ /  / / /\ \_\     / / /\ \ \   / / /  \ \ \        / /\/_/   /  \____\__/ / ]],
    [[    / / /  \/____/  / /_/_ \/_/    / / /  \ \_\  \ \ \   \_\ \      / / /     / /\/________/  ]],
    [[   / / /    / / /  / /____/\      / / /   / / /   \ \ \  / / /     / / /     / / /\/_// / /   ]],
    [[  / / /    / / /  / /\____\/     / / /   / / /     \ \ \/ / /     / / /     / / /    / / /    ]],
    [[ / / /    / / /  / / /______    / / /___/ / /       \ \ \/ /  ___/ / /__   / / /    / / /     ]],
    [[/ / /    / / /  / / /_______\  / / /____\/ /         \ \  /  /\__\/_/___\  \/_/    / / /      ]],
    [[\/_/     \/_/   \/__________/  \/_________/           \_\/   \/_________/          \/_/       ]]
  },
  {
    [[ _____  ___     _______      ______     ___      ___   __      ___      ___ ]],
    [[(\"   \|"  \   /"     "|    /    " \   |"  \    /"  | |" \    |"  \    /"  |]],
    [[|.\\   \    | (: ______)   // ____  \   \   \  //  /  |│  |    \   \  //   |]],
    [[|: \.   \\  |  \/    |    /  /    ) :)   \\  \/. ./   |:  |    /\\  \/.    |]],
    [[|.  \    \. |  // ___)_  (: (____/ //     \.    //    |.  |   |: \.        |]],
    [[|    \    \ | (:      "|  \        /       \\   /     /\  |\  |.  \    /:  |]],
    [[ \___|\____\)  \_______)   \"_____/         \__/     (__\_|_) |___|\__/|___|]]
  },
  {
    [[  __   __      _____     _____      _     _     __     __    __  ]],
    [[ /_/\ /\_\   /\_____\   ) ___ (    /_/\ /\_\   /\_\   /_/\  /\_\ ]],
    [[ ) ) \ ( (  ( (_____/  / /\_/\ \   ) ) ) ( (   \/_/   ) ) \/ ( ( ]],
    [[/_/   \ \_\  \ \__\   / /_/ (_\ \ /_/ / \ \_\   /\_\ /_/ \  / \_\]],
    [[\ \ \   / /  / /__/_  \ \ )_/ / / \ \ \_/ / /  / / / \ \ \\// / /]],
    [[ )_) \ (_(  ( (_____\  \ \/_\/ /   \ \   / /  ( (_(   )_) )( (_( ]],
    [[ \_\/ \/_/   \/_____/   )_____(     \_\_/_/    \/_/   \_\/  \/_/ ]]
  },
  {
    [[ ________     _______     ________    ___      ___   ___    _____ ______      ]],
    [[|\   ___  \  |\  ___ \   |\   __  \  |\  \    /  /| |\  \  |\   _ \  _   \    ]],
    [[\ \  \\ \  \ \ \   __/|  \ \  \|\  \ \ \  \  /  / / \ \  \ \ \  \\\__\ \  \   ]],
    [[ \ \  \\ \  \ \ \  \_|/__ \ \  \\\  \ \ \  \/  / /   \ \  \ \ \  \\|__| \  \  ]],
    [[  \ \  \\ \  \ \ \  \_|\ \ \ \  \\\  \ \ \    / /     \ \  \ \ \  \    \ \  \ ]],
    [[   \ \__\\ \__\ \ \_______\ \ \_______\ \ \__/ /       \ \__\ \ \__\    \ \__\]],
    [[    \|__| \|__|  \|_______|  \|_______|  \|__|/         \|__|  \|__|     \|__|]]
  },
  {
    [[_|      _|   _|_|_|_|     _|_|     _|      _|   _|_|_|   _|      _|]],
    [[_|_|    _|   _|         _|    _|   _|      _|     _|     _|_|  _|_|]],
    [[_|  _|  _|   _|_|_|     _|    _|   _|      _|     _|     _|  _|  _|]],
    [[_|    _|_|   _|         _|    _|     _|  _|       _|     _|      _|]],
    [[_|      _|   _|_|_|_|     _|_|         _|       _|_|_|   _|      _|]]
  },
  {
    [[_____   __                     _____             ]],
    [[___  | / /_____ ______ ___   _____(_)_______ ___ ]],
    [[__   |/ / _  _ \_  __ \__ | / /__  / __  __ `__ \]],
    [[_  /|  /  /  __// /_/ /__ |/ / _  /  _  / / / / /]],
    [[/_/ |_/   \___/ \____/ _____/  /_/   /_/ /_/ /_/ ]]
  },
  {
    [[ooooo      ooo oooooooooooo   .oooooo.   oooooo     oooo ooooo ooo        ooooo]],
    [[`888b.     `8' `888'     `8  d8P'  `Y8b   `888.     .8'  `888' `88.       .888']],
    [[ 8 `88b.    8   888         888      888   `888.   .8'    888   888b     d'888 ]],
    [[ 8   `88b.  8   888oooo8    888      888    `888. .8'     888   8 Y88. .P  888 ]],
    [[ 8     `88b.8   888    "    888      888     `888.8'      888   8  `888'   888 ]],
    [[ 8       `888   888       o `88b    d88'      `888'       888   8    Y     888 ]],
    [[o8o        `8  o888ooooood8  `Y8bood8P'        `8'       o888o o8o        o888o]]
  },
  {
    [[      ::::    :::   ::::::::::   ::::::::   :::     :::   :::::::::::     :::   :::]],
    [[     :+:+:   :+:   :+:         :+:    :+:  :+:     :+:       :+:        :+:+: :+:+:]],
    [[    :+:+:+  +:+   +:+         +:+    +:+  +:+     +:+       +:+       +:+ +:+:+ +:+]],
    [[   +#+ +:+ +#+   +#++:++#    +#+    +:+  +#+     +:+       +#+       +#+  +:+  +#+ ]],
    [[  +#+  +#+#+#   +#+         +#+    +#+   +#+   +#+        +#+       +#+       +#+  ]],
    [[ #+#   #+#+#   #+#         #+#    #+#    #+#+#+#         #+#       #+#       #+#   ]],
    [[###    ####   ##########   ########       ###       ###########   ###       ###    ]]
  }
}

return M
