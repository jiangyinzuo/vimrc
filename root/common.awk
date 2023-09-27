function countNonEmptyFields() {
	count = 0
	for (i = 1; i <= NF; ++i) {
		if ($i != "") {
			++count;
		}
	}
	return count;
}
