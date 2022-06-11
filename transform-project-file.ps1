param($projectFile, $nugetFolder)

# Test if project file exists
if(-Not(Test-Path -Path $projectFile -PathType Leaf)) 
{
    Write-Error "Project file not found"
    exit(1);
}

# Test if nuget folder exists
if(-Not(Test-Path -Path $nugetFolder -PathType Container)) 
{
    Write-Error "Nuget folder file not found"
    exit(1);
}

# load project file xml
$xml = New-Object System.Xml.XmlDocument
$xml.Load($projectFile)

# check if RestoreAdditionalProjectSources is present in project file, if not add it
$restoreNodeExists = 'false'

foreach($propertyGroup in $xml.Project.PropertyGroup)
{
    $restoreNode = $propertyGroup.RestoreAdditionalProjectSources

    if($restoreNode) 
    {
        $restoreNodeExists = 'true'
        break
    }
}

if($restoreNodeExists -eq 'false')
{
    Write-Host "Adding restore node"
    $propertyGroup = Select-XML -Xml $xml -XPath '//PropertyGroup[1]'
    $newNode = $xml.CreateElement('RestoreAdditionalProjectSources')
    $newNode.InnerText = '../../Nuget'
    $propertyGroup.Node.AppendChild($newNode)    
}


#get all nuget packages
$nugetPackagesFiles = (Get-ChildItem -Path $nugetFolder\ -Filter *.nupkg).Name

$nugetPackages = New-Object -TypeName "System.Collections.ArrayList"

foreach ($file in $nugetPackagesFiles)
{
    $file = $file.Replace('.nupkg','')
    $nugetPackages.Add($file)
}

#get all project references, and convert them to package references
$references = Select-XML -xml $xml -XPath '//ProjectReference'

foreach($item in (Select-XML -xml $xml -XPath '//ProjectReference'))
{
    # get the project name from the project reference
    $include = $item.node.Include
    $projectName = $include.SubString($include.LastIndexOf('\')+1).Replace('.csproj', '')

    $nugetPackageMatch = $nugetPackages | Where-Object { $_ -like "$projectName*"}

    $newNode = $xml.CreateElement("PackageReference")
    $includeAttribute = $xml.CreateAttribute("Include")
    $includeAttribute.Value = $projectName
    $newNode.Attributes.Append($includeAttribute)
    $versionAttribute = $xml.CreateAttribute("Version")
    $versionAttribute.Value = $nugetPackageMatch.Replace("$projectName.","")
    $newNode.Attributes.Append($versionAttribute)
    $item.node.ParentNode.AppendChild($newNode)
          
    #remove the project reference   
    $item.node.ParentNode.RemoveChild($item.node)          
     
}


$xml.Save($projectFile)