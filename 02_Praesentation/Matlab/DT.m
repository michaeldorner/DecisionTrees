load fisheriris
tc = ClassificationTree.fit(meas,species)
view(tc, 'mode', 'graph') % text description
