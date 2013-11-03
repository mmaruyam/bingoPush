INSERT INTO `bingo_master`
(
    `manager_id`,
    `table_name`,
    `number`,
    `create`
)
VALUE
(
    :userid,
    'hogehoge',
    :number,
    NOW()
)
