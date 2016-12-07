// v1.0 - 2/12/2016 - written by Rovian Veronez at ADR for a different project and I used in one of my projects

public static class stringManipulation
    {
        public static string Mid(this string text, int startIndex, int length)
        {
            if (text.Length > startIndex)
            {
                if (startIndex + length > text.Length)
                    return text.Substring(startIndex);

                return text.Substring(startIndex, length);
            }
            else
            {
                return "";
            }
        }

        public static string MaxChars(this string text, int max)
        {
            if (text.Length > max)
            {
                return text.Substring(0, max);
            }
            else
            {
                return text;
            }
        }

        public static string SurroundWith(this string text, string ends)
        {
            return ends + text + ends;
        }

        public static string FillLeft(this object value, int maxLength, char chr = ' ')
        {
            if (value == null) return new String(chr, maxLength);

            var sValue = value.ToString();
            if (string.IsNullOrEmpty(sValue)) return new String(chr, maxLength);
            sValue = sValue.Trim();
            return sValue.Length <= maxLength ? sValue.PadLeft(maxLength, chr) : sValue.Substring(0, maxLength);
        }

        public static string FillRight(this object value, int maxLength, char chr = ' ')
        {

            if (value == null) return new String(chr, maxLength);

            var sValue = value.ToString();

            if (string.IsNullOrEmpty(sValue)) return new String(chr, maxLength);

            sValue = sValue.Trim();
            return sValue.Length <= maxLength ? sValue.PadRight(maxLength, chr) : sValue.Substring(0, maxLength);
        }

        public static string NullTrim(this string value)
        {

            if (value == null) return null;

            return value.Trim();
        }
}
