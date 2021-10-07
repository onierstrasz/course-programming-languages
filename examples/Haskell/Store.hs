
import HUnit

-- ==================================================
-- Modelling Environments
-- ==================================================

newstore id = 0

update id val store = store'
    where store' id'
            | id' == id        = val
            | otherwise        = store id'

env1 = update 'a' 1 (update 'b' 2 (newstore))
env2 = update 'b' 3 env1

-- env1 'b'
-- env2 'b'
-- env2 'z'

test123 =    Test "env1" (\x -> env1 'b' == 2)
        :+:    Test "env2" (\x -> env2 'b' == 3)
        :+:    Test "env3" (\x -> env2 'z' == 0)

id <<- val = \ store -> update id val store

env3 = ('b' <<- 4) env1

env4 = ('a' <<- 1) (('b' <<- 3) (('c' <<- 2) newstore))

test34 =    Test "env3" (\x -> env3 'b' == 4)
        :+:    Test "env4" (\x -> env4 'z' == 0)
        :+:    Test "env4" (\x -> env4 'b' == 3)

-- env4 'b'
-- ('b' <<- 10) env4 'b'

-- ==================================================

tests = test123 :+: test34

main = assert "Store" tests

-- ==================================================
