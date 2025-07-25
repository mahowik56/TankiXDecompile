namespace YamlDotNet.Core.Events
{
	public class StreamStart : ParsingEvent
	{
		public override int NestingIncrease
		{
			get
			{
				return 1;
			}
		}

		internal override EventType Type
		{
			get
			{
				return EventType.StreamStart;
			}
		}

		public StreamStart()
			: this(Mark.Empty, Mark.Empty)
		{
		}

		public StreamStart(Mark start, Mark end)
			: base(start, end)
		{
		}

		public override string ToString()
		{
			return "Stream start";
		}

		public override void Accept(IParsingEventVisitor visitor)
		{
			visitor.Visit(this);
		}
	}
}
