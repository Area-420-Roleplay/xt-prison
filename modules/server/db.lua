local qb = (GetResourceState('qb-core') == 'started' or GetResourceState('qbx_core') == 'started')
local esx = (GetResourceState('es_extended') == 'started')
local ox = (GetResourceState('ox_core') == 'started')
local nd = lib.checkDependency('ND_Core', '2.0.0')

local db = {
    table = qb and 'players' or esx and 'users' or nd and 'nd_characters' or ox and 'characters',
    identifier = qb and 'citizenid' or esx and 'identifier' or nd and 'charid' or ox and 'charid',
}

MySQL.query([=[
    CREATE TABLE IF NOT EXISTS `xt_prison` (
        `identifier` VARCHAR(100) NOT NULL,
        `jailtime` INT(11) NOT NULL DEFAULT '0',
        PRIMARY KEY (`identifier`) USING BTREE
    );
]=])

MySQL.query(("SELECT COUNT(COLUMN_NAME) as count FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = '%s' AND COLUMN_NAME = 'jailtime'"):format(db.table), function(convertNeeded)
    if convertNeeded[1].count ~= 0 and convertNeeded[1].count > 1 then
        local rows = MySQL.query.await(('SELECT %s, jailtime FROM %s'):format(db.identifier, db.table))
        for _, row in ipairs(rows) do
            MySQL.query.await('INSERT INTO xt_prison (identifier, jailtime) VALUES (?, ?)', { row[db.identifier], row.jailtime })
        end
        MySQL.query.await(('ALTER TABLE %s DROP COLUMN jailtime'):format(db.table))
    end
end)

return {
    UPDATE_JAILTIME = 'INSERT INTO xt_prison (identifier, jailtime) VALUES (?, ?) ON DUPLICATE KEY UPDATE jailtime = VALUES(jailtime)',
    LOAD_JAILTIME = 'SELECT `jailtime` FROM xt_prison WHERE `identifier` = ?',
    GET_INVENTORY = 'SELECT * FROM ox_inventory WHERE `owner` = ? AND `name` = ?',
    DELETE_INVENTORY = 'DELETE FROM ox_inventory WHERE `name` = ?'
}