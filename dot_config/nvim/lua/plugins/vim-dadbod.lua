return {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = {
        'tpope/vim-dadbod',
        'tpope/vim-dotenv',
        { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
        { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
    },
    cmd = {
        "DBUI",
        "DBUIToggle",
        "DBUIAddConnection",
        "DBUIFindBuffer",
    },

    init = function()
        vim.g.db_ui_use_nerd_fonts = 1
        vim.g.db_ui_show_database_icon = 1
        -- vim.g.db_ui_force_echo_notifications = 1
        vim.g.db_ui_win_position = 'left'
        vim.g.db_ui_winwidth = 40

        vim.g.db_ui_default_query_tool = '/opt/mssql-tools/bin/sqlcmd'

        vim.g.db_ui_table_helpers = {
            mysql = {
                Count = "select count(1) from {optional_schema}{table}",
                Explain = "EXPLAIN {last_query}",
                SearchTable =
                "SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE LOWER(TABLE_NAME) LIKE LOWER('%{table}%')",
                ColumnName = [[
            SELECT
            COLUMN_NAME AS 'ColumnName',
            TABLE_NAME AS 'TableName' FROM INFORMATION_SCHEMA.COLUMNS
            WHERE LOWER(COLUMN_NAME) LIKE LOWER('%column_name%')
            ORDER BY TableName, ColumnName
            ]],
                ColumnInfo = [[
            SELECT COLUMN_NAME,
            CONCAT(DATA_TYPE,
            CASE
                WHEN CHARACTER_MAXIMUM_LENGTH IS NOT NULL THEN CONCAT(' (', CAST(CHARACTER_MAXIMUM_LENGTH AS CHAR), ')')
                ELSE ''
            END) AS DATA_TYPE
            FROM INFORMATION_SCHEMA.COLUMNS
            WHERE TABLE_NAME = '{table}';
        ]]
            },
            sqlite = {
                Describe = "PRAGMA table_info({table})"
            },
            sqlserver = {
                tables = "select TABLE_NAME from INFORMATION_SCHEMA.TABLES where TABLE_TYPE = 'BASE TABLE';",
                SearchTable = [[
            SELECT TABLE_NAME
            FROM INFORMATION_SCHEMA.TABLES
            WHERE LOWER(TABLE_NAME) LIKE LOWER('%{table}%');
        ]],

                SearchColumn = [[
            SELECT COLUMN_NAME AS 'ColumnName',
            TABLE_NAME AS 'TableName'
            FROM INFORMATION_SCHEMA.COLUMNS
            WHERE LOWER(COLUMN_NAME) LIKE LOWER('%column_name%')
            ORDER BY TableName, ColumnName;
        ]],

                ColumnInfo = [[
            SELECT c.COLUMN_NAME,
            c.DATA_TYPE +
            CASE
                WHEN c.CHARACTER_MAXIMUM_LENGTH IS NOT NULL THEN ' (' + CAST(c.CHARACTER_MAXIMUM_LENGTH AS VARCHAR(20)) + ')'
                ELSE ''
            END AS DATA_TYPE
            FROM INFORMATION_SCHEMA.COLUMNS c
            WHERE c.TABLE_NAME = '{table_name}';
        ]]
            },
        }

        vim.g.db_ui_icons = {
            expanded = {
                db = '▾ ',
                buffers = '▾ ',
                saved_queries = '▾ ',
                schemas = '▾ ',
                schema = '▾ פּ',
                tables = '▾ 藺',
                table = '▾ ',
            },
            collapsed = {
                db = '▸ ',
                buffers = '▸ ',
                saved_queries = '▸ ',
                schemas = '▸ ',
                schema = '▸ פּ',
                tables = '▸ 藺',
                table = '▸ ',
            },
            saved_query = '',
            new_query = '璘',
            tables = '離',
            buffers = '﬘',
            add_connection = '',
            connection_ok = '✓',
            connection_error = '✕',
        }

        -- opening it in a new tab
        vim.keymap.set('n', '<leader><leader>db', ':tab DBUI<cr>', {})

        -- just close the tab, but context related of the keybinding
        vim.keymap.set('n', '<leader><leader>tq', ':tabclose<cr>')

        vim.api.nvim_create_autocmd("FileType", {
            pattern = "sql",
            callback = function()
                vim.bo.omnifunc = "vim_dadbod_completion#omni"
            end,
        })
    end,
}
