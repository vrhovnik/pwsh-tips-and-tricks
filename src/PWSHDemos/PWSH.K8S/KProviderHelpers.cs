using System.Management.Automation;

namespace PWSH.K8S;

/// <summary>
/// helper functions to get the path right
/// </summary>
/// <remarks>
///     check out documentation here <see cref="https://learn.microsoft.com/en-us/powershell/scripting/developer/provider/writing-a-navigation-provider?view=powershell-7.3"/>
/// </remarks>
public static class KProviderHelpers
{
    public const string PathSeparator = "\\";
    
    /// <summary>
    /// Checks if a given path is actually a drive name.
    /// </summary>
    /// <param name="path">The path to check.</param>
    /// <returns>
    /// True if the path given represents a drive, false otherwise.
    /// </returns>
    /// <remarks>
    /// Remove the drive name and first path separator.  If the path is reduced to nothing, it is a drive.
    /// Also if its just a drive then there wont be any path separators
    /// </remarks>
    public static bool PathIsDrive(this string path, PSDriveInfo psDriveInfo) =>
        string.IsNullOrEmpty(path.Replace(psDriveInfo.Root, "")) ||
        string.IsNullOrEmpty(path.Replace(psDriveInfo.Root + PathSeparator, ""));  // PathIsDrive

    /// <summary>
    /// Breaks up the path into individual elements.
    /// </summary>
    /// <param name="path">The path to split.</param>
    /// <returns>An array of path segments.</returns>
    public static string[] ChunkPath(this string path, PSDriveInfo psDriveInfo)
    {
        var normalPath = NormalizePath(path); //normalize path to remove chars
        var pathNoDrive = normalPath.Replace(psDriveInfo.Root + PathSeparator, "");
        return pathNoDrive.Split(PathSeparator.ToCharArray());
    } // ChunkPath

    /// <summary>
    /// Adapts the path, making sure the correct path separator
    /// character is used.
    /// </summary>
    /// <param name="path"></param>
    /// <returns>normalized path or same path</returns>
    public static string NormalizePath(this string path)
    {
        var result = path;
        if (!string.IsNullOrEmpty(path)) result = path.Replace("/", PathSeparator);
        return result;
    } // NormalizePath
}