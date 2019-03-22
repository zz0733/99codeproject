<GameFile>
  <PropertyGroup Name="RBWarPageRewardStart" Type="Layer" ID="dbf013cd-71f1-48f1-9e85-054fe2d8191c" Version="3.10.0.0" />
  <Content ctype="GameProjectContent">
    <Content>
      <Animation Duration="70" Speed="0.5000" ActivedAnimationName="show">
        <Timeline ActionTag="-780996499" Property="Alpha">
          <IntFrame FrameIndex="60" Value="255" />
          <IntFrame FrameIndex="70" Value="0" />
        </Timeline>
        <Timeline ActionTag="1418637965" Property="Scale">
          <ScaleFrame FrameIndex="0" X="0.1000" Y="0.1000" />
          <ScaleFrame FrameIndex="10" X="1.0500" Y="1.0500" />
          <ScaleFrame FrameIndex="16" X="1.0000" Y="1.0000" />
        </Timeline>
        <Timeline ActionTag="1418637965" Property="Alpha">
          <IntFrame FrameIndex="0" Value="0" />
          <IntFrame FrameIndex="10" Value="255" />
        </Timeline>
        <Timeline ActionTag="1051506804" Property="Alpha">
          <IntFrame FrameIndex="60" Value="255" />
          <IntFrame FrameIndex="70" Value="0" />
        </Timeline>
      </Animation>
      <AnimationList>
        <AnimationInfo Name="show" StartIndex="0" EndIndex="60">
          <RenderColor A="255" R="134" G="244" B="84" />
        </AnimationInfo>
        <AnimationInfo Name="out" StartIndex="60" EndIndex="70">
          <RenderColor A="255" R="220" G="108" B="229" />
        </AnimationInfo>
      </AnimationList>
      <ObjectData Name="Layer" ctype="GameLayerObjectData">
        <Size X="1280.0000" Y="720.0000" />
        <Children>
          <AbstractNodeData Name="mask" ActionTag="-780996499" Tag="18" IconVisible="True" TouchEnable="True" ClipAble="False" BackColorAlpha="178" ComboBoxIndex="1" ColorAngle="0.0000" CascadeColorEnabled="True" CascadeOpacityEnabled="True" FlipX="False" FlipY="False" IsCustomSize="True" ctype="PanelObjectData">
            <Size X="1280.0000" Y="720.0000" />
            <AnchorPoint />
            <Position />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="0" G="0" B="0" />
            <PrePosition />
            <PreSize X="1.0000" Y="1.0000" />
            <SingleColor A="255" R="0" G="0" B="0" />
            <FirstColor A="255" R="150" G="200" B="255" />
            <EndColor A="255" R="255" G="255" B="255" />
            <ColorVector ScaleY="1.0000" />
          </AbstractNodeData>
          <AbstractNodeData Name="Panel" ActionTag="-127250978" Tag="1570" IconVisible="True" TouchEnable="True" ClipAble="False" BackColorAlpha="102" ColorAngle="0.0000" CascadeColorEnabled="True" CascadeOpacityEnabled="True" FlipX="False" FlipY="False" IsCustomSize="True" ctype="PanelObjectData">
            <Size X="1280.0000" Y="720.0000" />
            <Children>
              <AbstractNodeData Name="center" ActionTag="1051506804" Tag="19" IconVisible="True" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="640.0000" RightMargin="640.0000" TopMargin="360.0000" BottomMargin="360.0000" CascadeColorEnabled="True" CascadeOpacityEnabled="True" StretchWidthEnable="False" StretchHeightEnable="False" ctype="SingleNodeObjectData">
                <Size X="0.0000" Y="0.0000" />
                <Children>
                  <AbstractNodeData Name="light" ActionTag="634450477" Tag="20" IconVisible="True" LeftMargin="-271.0000" RightMargin="-271.0000" TopMargin="-331.0000" BottomMargin="-211.0000" CascadeColorEnabled="True" CascadeOpacityEnabled="True" StretchWidthEnable="False" StretchHeightEnable="False" IntelliShadingEnabled="False" ctype="SpriteObjectData">
                    <Size X="542.0000" Y="542.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position Y="60.0000" />
                    <Scale ScaleX="1.3000" ScaleY="1.3000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition />
                    <PreSize X="0.0000" Y="0.0000" />
                    <FileData Type="PlistSubImage" Path="gq1.png" Plist="RBWar/image/rbweffectbigWinner.plist" />
                    <BlendFunc Src="1" Dst="771" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="title" ActionTag="-387615852" Tag="27" IconVisible="True" LeftMargin="-166.4997" RightMargin="-166.5003" TopMargin="-152.0000" BottomMargin="58.0000" CascadeColorEnabled="True" CascadeOpacityEnabled="True" StretchWidthEnable="False" StretchHeightEnable="False" IntelliShadingEnabled="False" ctype="SpriteObjectData">
                    <Size X="333.0000" Y="94.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="0.0003" Y="105.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition />
                    <PreSize X="0.0000" Y="0.0000" />
                    <FileData Type="PlistSubImage" Path="rbwImg1/jckj_jckj.png" Plist="RBWar/image/rbwarCCSImg1.plist" />
                    <BlendFunc Src="1" Dst="771" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="pool" ActionTag="1418637965" Tag="196" IconVisible="True" LeftMargin="-271.4999" RightMargin="-271.5001" TopMargin="-54.5000" BottomMargin="-70.5000" CascadeColorEnabled="True" CascadeOpacityEnabled="True" StretchWidthEnable="False" StretchHeightEnable="False" IntelliShadingEnabled="False" ctype="SpriteObjectData">
                    <Size X="543.0000" Y="125.0000" />
                    <Children>
                      <AbstractNodeData Name="0" ActionTag="1885499026" Tag="197" IconVisible="True" LeftMargin="18.0000" RightMargin="473.0000" TopMargin="21.0000" BottomMargin="36.0000" CascadeColorEnabled="True" CascadeOpacityEnabled="True" StretchWidthEnable="False" StretchHeightEnable="False" IntelliShadingEnabled="False" ctype="SpriteObjectData">
                        <Size X="52.0000" Y="68.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="44.0000" Y="70.0000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.0810" Y="0.5600" />
                        <PreSize X="0.0958" Y="0.5440" />
                        <FileData Type="PlistSubImage" Path="rbwnum_07/0.png" Plist="RBWar/image/rbwarCCSImg0.plist" />
                        <BlendFunc Src="1" Dst="771" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="1" ActionTag="-525517951" Tag="198" IconVisible="True" LeftMargin="76.0000" RightMargin="415.0000" TopMargin="21.0000" BottomMargin="36.0000" CascadeColorEnabled="True" CascadeOpacityEnabled="True" StretchWidthEnable="False" StretchHeightEnable="False" IntelliShadingEnabled="False" ctype="SpriteObjectData">
                        <Size X="52.0000" Y="68.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="102.0000" Y="70.0000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.1878" Y="0.5600" />
                        <PreSize X="0.0958" Y="0.5440" />
                        <FileData Type="PlistSubImage" Path="rbwnum_07/1.png" Plist="RBWar/image/rbwarCCSImg0.plist" />
                        <BlendFunc Src="1" Dst="771" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="2" ActionTag="1796583039" Tag="199" IconVisible="True" LeftMargin="135.0000" RightMargin="356.0000" TopMargin="21.0000" BottomMargin="36.0000" CascadeColorEnabled="True" CascadeOpacityEnabled="True" StretchWidthEnable="False" StretchHeightEnable="False" IntelliShadingEnabled="False" ctype="SpriteObjectData">
                        <Size X="52.0000" Y="68.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="161.0000" Y="70.0000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.2965" Y="0.5600" />
                        <PreSize X="0.0958" Y="0.5440" />
                        <FileData Type="PlistSubImage" Path="rbwnum_07/2.png" Plist="RBWar/image/rbwarCCSImg0.plist" />
                        <BlendFunc Src="1" Dst="771" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="3" ActionTag="188482915" Tag="200" IconVisible="True" LeftMargin="193.0000" RightMargin="298.0000" TopMargin="21.0000" BottomMargin="36.0000" CascadeColorEnabled="True" CascadeOpacityEnabled="True" StretchWidthEnable="False" StretchHeightEnable="False" IntelliShadingEnabled="False" ctype="SpriteObjectData">
                        <Size X="52.0000" Y="68.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="219.0000" Y="70.0000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.4033" Y="0.5600" />
                        <PreSize X="0.0958" Y="0.5440" />
                        <FileData Type="PlistSubImage" Path="rbwnum_07/3.png" Plist="RBWar/image/rbwarCCSImg0.plist" />
                        <BlendFunc Src="1" Dst="771" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="4" ActionTag="2069237173" Tag="201" IconVisible="True" LeftMargin="246.5000" RightMargin="244.5000" TopMargin="21.0000" BottomMargin="36.0000" CascadeColorEnabled="True" CascadeOpacityEnabled="True" StretchWidthEnable="False" StretchHeightEnable="False" IntelliShadingEnabled="False" ctype="SpriteObjectData">
                        <Size X="52.0000" Y="68.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="272.5000" Y="70.0000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.5018" Y="0.5600" />
                        <PreSize X="0.0958" Y="0.5440" />
                        <FileData Type="PlistSubImage" Path="rbwnum_07/4.png" Plist="RBWar/image/rbwarCCSImg0.plist" />
                        <BlendFunc Src="1" Dst="771" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="5" ActionTag="501981951" Tag="202" IconVisible="True" LeftMargin="301.0000" RightMargin="190.0000" TopMargin="21.0000" BottomMargin="36.0000" CascadeColorEnabled="True" CascadeOpacityEnabled="True" StretchWidthEnable="False" StretchHeightEnable="False" IntelliShadingEnabled="False" ctype="SpriteObjectData">
                        <Size X="52.0000" Y="68.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="327.0000" Y="70.0000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.6022" Y="0.5600" />
                        <PreSize X="0.0958" Y="0.5440" />
                        <FileData Type="PlistSubImage" Path="rbwnum_07/5.png" Plist="RBWar/image/rbwarCCSImg0.plist" />
                        <BlendFunc Src="1" Dst="771" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="6" ActionTag="1124719386" Tag="203" IconVisible="True" LeftMargin="360.0000" RightMargin="131.0000" TopMargin="21.0000" BottomMargin="36.0000" CascadeColorEnabled="True" CascadeOpacityEnabled="True" StretchWidthEnable="False" StretchHeightEnable="False" IntelliShadingEnabled="False" ctype="SpriteObjectData">
                        <Size X="52.0000" Y="68.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="386.0000" Y="70.0000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.7109" Y="0.5600" />
                        <PreSize X="0.0958" Y="0.5440" />
                        <FileData Type="PlistSubImage" Path="rbwnum_07/6.png" Plist="RBWar/image/rbwarCCSImg0.plist" />
                        <BlendFunc Src="1" Dst="771" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="7" ActionTag="-1268593285" Tag="204" IconVisible="True" LeftMargin="414.0000" RightMargin="77.0000" TopMargin="21.0000" BottomMargin="36.0000" CascadeColorEnabled="True" CascadeOpacityEnabled="True" StretchWidthEnable="False" StretchHeightEnable="False" IntelliShadingEnabled="False" ctype="SpriteObjectData">
                        <Size X="52.0000" Y="68.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="440.0000" Y="70.0000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.8103" Y="0.5600" />
                        <PreSize X="0.0958" Y="0.5440" />
                        <FileData Type="PlistSubImage" Path="rbwnum_07/7.png" Plist="RBWar/image/rbwarCCSImg0.plist" />
                        <BlendFunc Src="1" Dst="771" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="8" ActionTag="1882962220" Tag="205" IconVisible="True" LeftMargin="473.0000" RightMargin="18.0000" TopMargin="21.0000" BottomMargin="36.0000" CascadeColorEnabled="True" CascadeOpacityEnabled="True" StretchWidthEnable="False" StretchHeightEnable="False" IntelliShadingEnabled="False" ctype="SpriteObjectData">
                        <Size X="52.0000" Y="68.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="499.0000" Y="70.0000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.9190" Y="0.5600" />
                        <PreSize X="0.0958" Y="0.5440" />
                        <FileData Type="PlistSubImage" Path="rbwnum_07/8.png" Plist="RBWar/image/rbwarCCSImg0.plist" />
                        <BlendFunc Src="1" Dst="771" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="0.0001" Y="-8.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition />
                    <PreSize X="0.0000" Y="0.0000" />
                    <FileData Type="PlistSubImage" Path="rbwImg1/caici2.png" Plist="RBWar/image/rbwarCCSImg1.plist" />
                    <BlendFunc Src="1" Dst="771" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint />
                <Position X="640.0000" Y="360.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5000" Y="0.5000" />
                <PreSize X="0.0000" Y="0.0000" />
              </AbstractNodeData>
              <AbstractNodeData Name="lotteryPool" ActionTag="-1855433949" Tag="608" IconVisible="True" PositionPercentXEnabled="True" VerticalEdge="TopEdge" LeftMargin="471.0000" RightMargin="471.0000" TopMargin="28.0000" BottomMargin="534.0000" TouchEnable="True" CascadeColorEnabled="True" CascadeOpacityEnabled="True" ctype="ImageViewObjectData">
                <Size X="338.0000" Y="158.0000" />
                <Children>
                  <AbstractNodeData Name="0" ActionTag="-209258198" Tag="609" IconVisible="True" LeftMargin="24.5000" RightMargin="278.5000" TopMargin="92.5000" BottomMargin="16.5000" CascadeColorEnabled="True" CascadeOpacityEnabled="True" StretchWidthEnable="False" StretchHeightEnable="False" IntelliShadingEnabled="False" ctype="SpriteObjectData">
                    <Size X="35.0000" Y="49.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="42.0000" Y="41.0000" />
                    <Scale ScaleX="0.8500" ScaleY="0.8500" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.1243" Y="0.2595" />
                    <PreSize X="0.1036" Y="0.3101" />
                    <FileData Type="PlistSubImage" Path="rbwnum_01/0.png" Plist="RBWar/image/rbwarCCSImg0.plist" />
                    <BlendFunc Src="1" Dst="771" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="1" ActionTag="738890822" Tag="610" IconVisible="True" LeftMargin="59.5000" RightMargin="243.5000" TopMargin="92.5000" BottomMargin="16.5000" CascadeColorEnabled="True" CascadeOpacityEnabled="True" StretchWidthEnable="False" StretchHeightEnable="False" IntelliShadingEnabled="False" ctype="SpriteObjectData">
                    <Size X="35.0000" Y="49.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="77.0000" Y="41.0000" />
                    <Scale ScaleX="0.8500" ScaleY="0.8500" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.2278" Y="0.2595" />
                    <PreSize X="0.1036" Y="0.3101" />
                    <FileData Type="PlistSubImage" Path="rbwnum_01/1.png" Plist="RBWar/image/rbwarCCSImg0.plist" />
                    <BlendFunc Src="1" Dst="771" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="2" ActionTag="-2096248291" Tag="611" IconVisible="True" LeftMargin="91.5000" RightMargin="211.5000" TopMargin="92.5000" BottomMargin="16.5000" CascadeColorEnabled="True" CascadeOpacityEnabled="True" StretchWidthEnable="False" StretchHeightEnable="False" IntelliShadingEnabled="False" ctype="SpriteObjectData">
                    <Size X="35.0000" Y="49.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="109.0000" Y="41.0000" />
                    <Scale ScaleX="0.8500" ScaleY="0.8500" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.3225" Y="0.2595" />
                    <PreSize X="0.1036" Y="0.3101" />
                    <FileData Type="PlistSubImage" Path="rbwnum_01/2.png" Plist="RBWar/image/rbwarCCSImg0.plist" />
                    <BlendFunc Src="1" Dst="771" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="3" ActionTag="-1708700579" Tag="612" IconVisible="True" LeftMargin="124.5000" RightMargin="178.5000" TopMargin="92.5000" BottomMargin="16.5000" CascadeColorEnabled="True" CascadeOpacityEnabled="True" StretchWidthEnable="False" StretchHeightEnable="False" IntelliShadingEnabled="False" ctype="SpriteObjectData">
                    <Size X="35.0000" Y="49.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="142.0000" Y="41.0000" />
                    <Scale ScaleX="0.8500" ScaleY="0.8500" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.4201" Y="0.2595" />
                    <PreSize X="0.1036" Y="0.3101" />
                    <FileData Type="PlistSubImage" Path="rbwnum_01/3.png" Plist="RBWar/image/rbwarCCSImg0.plist" />
                    <BlendFunc Src="1" Dst="771" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="4" ActionTag="1740095994" Tag="613" IconVisible="True" LeftMargin="154.5000" RightMargin="148.5000" TopMargin="92.5000" BottomMargin="16.5000" CascadeColorEnabled="True" CascadeOpacityEnabled="True" StretchWidthEnable="False" StretchHeightEnable="False" IntelliShadingEnabled="False" ctype="SpriteObjectData">
                    <Size X="35.0000" Y="49.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="172.0000" Y="41.0000" />
                    <Scale ScaleX="0.8500" ScaleY="0.8500" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.5089" Y="0.2595" />
                    <PreSize X="0.1036" Y="0.3101" />
                    <FileData Type="PlistSubImage" Path="rbwnum_01/4.png" Plist="RBWar/image/rbwarCCSImg0.plist" />
                    <BlendFunc Src="1" Dst="771" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="5" ActionTag="574087854" Tag="614" IconVisible="True" LeftMargin="188.5000" RightMargin="114.5000" TopMargin="92.5000" BottomMargin="16.5000" CascadeColorEnabled="True" CascadeOpacityEnabled="True" StretchWidthEnable="False" StretchHeightEnable="False" IntelliShadingEnabled="False" ctype="SpriteObjectData">
                    <Size X="35.0000" Y="49.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="206.0000" Y="41.0000" />
                    <Scale ScaleX="0.8500" ScaleY="0.8500" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.6095" Y="0.2595" />
                    <PreSize X="0.1036" Y="0.3101" />
                    <FileData Type="PlistSubImage" Path="rbwnum_01/5.png" Plist="RBWar/image/rbwarCCSImg0.plist" />
                    <BlendFunc Src="1" Dst="771" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="6" ActionTag="-1307999451" Tag="615" IconVisible="True" LeftMargin="218.5000" RightMargin="84.5000" TopMargin="92.5000" BottomMargin="16.5000" CascadeColorEnabled="True" CascadeOpacityEnabled="True" StretchWidthEnable="False" StretchHeightEnable="False" IntelliShadingEnabled="False" ctype="SpriteObjectData">
                    <Size X="35.0000" Y="49.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="236.0000" Y="41.0000" />
                    <Scale ScaleX="0.8500" ScaleY="0.8500" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.6982" Y="0.2595" />
                    <PreSize X="0.1036" Y="0.3101" />
                    <FileData Type="PlistSubImage" Path="rbwnum_01/6.png" Plist="RBWar/image/rbwarCCSImg0.plist" />
                    <BlendFunc Src="1" Dst="771" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="7" ActionTag="-2086741101" Tag="616" IconVisible="True" LeftMargin="250.5000" RightMargin="52.5000" TopMargin="92.5000" BottomMargin="16.5000" CascadeColorEnabled="True" CascadeOpacityEnabled="True" StretchWidthEnable="False" StretchHeightEnable="False" IntelliShadingEnabled="False" ctype="SpriteObjectData">
                    <Size X="35.0000" Y="49.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="268.0000" Y="41.0000" />
                    <Scale ScaleX="0.8500" ScaleY="0.8500" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.7929" Y="0.2595" />
                    <PreSize X="0.1036" Y="0.3101" />
                    <FileData Type="PlistSubImage" Path="rbwnum_01/7.png" Plist="RBWar/image/rbwarCCSImg0.plist" />
                    <BlendFunc Src="1" Dst="771" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="8" ActionTag="1549767899" Tag="617" IconVisible="True" LeftMargin="284.0000" RightMargin="19.0000" TopMargin="92.5000" BottomMargin="16.5000" CascadeColorEnabled="True" CascadeOpacityEnabled="True" StretchWidthEnable="False" StretchHeightEnable="False" IntelliShadingEnabled="False" ctype="SpriteObjectData">
                    <Size X="35.0000" Y="49.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="301.5000" Y="41.0000" />
                    <Scale ScaleX="0.8500" ScaleY="0.8500" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.8920" Y="0.2595" />
                    <PreSize X="0.1036" Y="0.3101" />
                    <FileData Type="PlistSubImage" Path="rbwnum_01/8.png" Plist="RBWar/image/rbwarCCSImg0.plist" />
                    <BlendFunc Src="1" Dst="771" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="640.0000" Y="613.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5000" Y="0.8514" />
                <PreSize X="0.2641" Y="0.2194" />
                <FileData Type="PlistSubImage" Path="rbwImg1/caici.png" Plist="RBWar/image/rbwarCCSImg1.plist" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint />
            <Position />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition />
            <PreSize X="1.0000" Y="1.0000" />
            <SingleColor A="255" R="150" G="200" B="255" />
            <FirstColor A="255" R="150" G="200" B="255" />
            <EndColor A="255" R="255" G="255" B="255" />
            <ColorVector ScaleY="1.0000" />
          </AbstractNodeData>
        </Children>
      </ObjectData>
    </Content>
  </Content>
</GameFile>