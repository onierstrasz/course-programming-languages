#! /bin/sh
# (c) 2002 Oscar.Nierstrasz@acm.org

./lrun.sh '(\x.x) y'
./lrun.sh '\x.f x'
./lrun.sh 'x y'
./lrun.sh '(\x.x) (\x.x)'
./lrun.sh '(\x.x y) z'
./lrun.sh '(\x.\y.x) t f'
./lrun.sh '(\x.\y.\z.z x y) a b (\x.\y.x)'
./lrun.sh '(\f.\g.f g) (\x.x) (\x.x) z'
./lrun.sh '(\x.\y.x y) y'
./lrun.sh '(\x.\y.x y) (\x.x) (\x.x)'
./lrun.sh '(\x.\y.x y) ((\x.x) (\x.x))'

./lrun.sh 'hello world'

# ----- omega -----

# ./lrun.sh '((\x.x x) (\x.x x))'
./lrun.sh '(\x.y) ((\x.x x) (\x.x x))'

# ----- Booleans -----

./lrun.sh '(\True.True t f) (\x.\y.x)'

./lrun.sh '(\True.\False.True t f) (\x.\y.x) (\x.\y.y)'
./lrun.sh '(\True.\False.False t f) (\x.\y.x) (\x.\y.y)'


./lrun.sh '
(\True.\False.
	(\Not.
		Not True t f)
	(\b.b False True) )
(\x.\y.x) (\x.\y.y)
'

# ----- Pairs -----

./lrun.sh '
(\True.\False.
	(\Pair.\First.\Second.
		First (Pair a b) )
	(\x.\y.\z.z x y) (\p.p True) (\p.p False) )
(\x.\y.x) (\x.\y.y)
'

# ----- Natural Numbers -----

# Compute One
./lrun.sh '
(\True.\False.
	(\Pair.\First.\Second.
		(\Zero.\Succ.
			Succ Zero )
		(\x.x) (\n.Pair False n) )
	(\x.\y.\z.z x y) (\p.p True) (\p.p False) )
(\x.\y.x) (\x.\y.y)
'

# 10 steps -> \z.z (\x.\y.y) (\x.x)

# Test One
./lrun.sh '
(\True.\False.
	(\Pair.\First.\Second.
		(\Zero.\One.\IsZero.\Pred.
			IsZero (Pred One) t f )
		(\x.x) (\z.z (\x.\y.y) (\x.x)) First Second )
	(\x.\y.\z.z x y) (\p.p True) (\p.p False) )
(\x.\y.x) (\x.\y.y)
'

# ----- Fix Points -----

# Note that e FP <-> FP
./lrun.sh '(\Y.Y e) (\f.(\x.f (x x)) (\x.f (x x)))'


# from the lecture
./lrun.sh '
(\True.\Y.Y (\x.True))
(\x.\y.x)
(\f.(\x.f (x x)) (\x.f (x x)))
'

# Are Y Succ and Succ (Y Succ) really the same?
./lrun.sh '
(\True.\False.\Pair.\Y.
	(\Succ. Y Succ )
	(\n.Pair False n) )
(\x.\y.x) (\x.\y.y) (\x.\y.\z.z x y) (\f.(\x.f (x x)) (\x.f (x x)))
'
./lrun.sh '
(\True.\False.\Pair.\Y.
	(\Succ. Succ (Y Succ) )
	(\n.Pair False n) )
(\x.\y.x) (\x.\y.y) (\x.\y.\z.z x y) (\f.(\x.f (x x)) (\x.f (x x)))
'
# Yes, but you must eval underneath the resulting lambdas to see it

# ----- Recursive Functions (FP of Plus) -----

# Compute Two
./lrun.sh '
(\True.\False.\Y.
	(\Pair.\First.\Second.
		(\Zero.\Succ.\IsZero.\Pred.
			(\RPlus.\One.
				(\Plus.
					Plus One One )
				(Y RPlus) )
			(\plus.\n.\m.
				IsZero n
				m
				(plus (Pred n) (Succ m)))
			(Succ Zero) )
		(\x.x) (\n.Pair False n) First Second )
	(\x.\y.\z.z x y) (\p.p True) (\p.p False) )
(\x.\y.x) (\x.\y.y) (\f.(\x.f (x x)) (\x.f (x x)))
'

# 45 steps
# -> \z.z (\x.\y.y) ((\n.(\x.\y.\z.z x y) (\x.\y.y) n) (\x.x))


# Check Pred Pred Two = Zero?
./lrun.sh '
(\True.\False.
	(\Pair.\First.\Second.
		(\Zero.\Succ.\IsZero.\Pred.
			(\Two.
				IsZero (Pred (Pred Two)) t f )
			(\z.z (\x.\y.y)
				((\n.(\x.\y.\z.z x y)
					(\x.\y.y) n)
				 (\x.x))) )
		(\x.x) (\n.Pair False n) First Second )
	(\x.\y.\z.z x y) (\p.p True) (\p.p False) )
(\x.\y.x) (\x.\y.y)
'

# 25 steps -> yes
