def sort1(A, B, C):
	if (A < B):
		if (B < C):
			return [A, B, C]
		else:
			if (A < C):
				return [A, C, B]
			else:
				return [C, A, B]
	else:
		if (B < C):
			if (A < C):
				return [B, A, C]
			else:
				return [B, C, A]
		else:
			return [C, B, A]

def sort2(A, B, C):
	if (A < B) and (B < C) : return [A, B, C]
	if (A < B) and not (B < C) and (A < C): return [A, C, B]
	if (A < B) and not (B < C) and not (A < C): return [C, A, B]
	if not (A < B) and (B < C) and (A < C): return [B, A, C]
	if not (A < B) and (B < C) and not (A < C): return [B, C, A]
	if not (A < B) and not (B < C) : return [C, B, A]

print(sort1(9,-2,0))
print(sort2(2,0,0))