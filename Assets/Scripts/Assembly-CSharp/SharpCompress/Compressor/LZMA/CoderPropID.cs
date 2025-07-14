namespace SharpCompress.Compressor.LZMA
{
	internal enum CoderPropID
	{
		DefaultProp = 0,
		DictionarySize = 1,
		UsedMemorySize = 2,
		Order = 3,
		BlockSize = 4,
		PosStateBits = 5,
		LitContextBits = 6,
		LitPosBits = 7,
		NumFastBytes = 8,
		MatchFinder = 9,
		MatchFinderCycles = 10,
		NumPasses = 11,
		Algorithm = 12,
		NumThreads = 13,
		EndMarker = 14
	}
}
