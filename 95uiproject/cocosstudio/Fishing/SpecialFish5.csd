<GameFile>
  <PropertyGroup Name="SpecialFish5" Type="Node" ID="965caf25-5b8d-4c9e-9901-be8b546a69d7" Version="3.10.0.0" />
  <Content ctype="GameProjectContent">
    <Content>
      <Animation Duration="300" Speed="1.0000" ActivedAnimationName="">
        <Timeline ActionTag="1030628948" Property="Position">
          <PointFrame FrameIndex="0" X="0.0000" Y="0.0000" />
          <PointFrame FrameIndex="300" X="0.0000" Y="0.0000" />
        </Timeline>
        <Timeline ActionTag="1030628948" Property="Scale">
          <ScaleFrame FrameIndex="0" X="1.0000" Y="1.0000" />
          <ScaleFrame FrameIndex="300" X="1.0000" Y="1.0000" />
        </Timeline>
        <Timeline ActionTag="1030628948" Property="RotationSkew">
          <ScaleFrame FrameIndex="0" X="0.0000" Y="0.0000" />
          <ScaleFrame FrameIndex="300" X="360.0000" Y="360.0000" />
        </Timeline>
      </Animation>
      <AnimationList>
        <AnimationInfo Name="specialAct" StartIndex="0" EndIndex="300">
          <RenderColor A="255" R="169" G="98" B="177" />
        </AnimationInfo>
      </AnimationList>
      <ObjectData Name="Node" ctype="GameNodeObjectData">
        <Children>
          <AbstractNodeData Name="fish_pos1" ActionTag="1030628948" Tag="227" IconVisible="True" LeftMargin="-80.0000" RightMargin="-80.0000" TopMargin="-80.0000" BottomMargin="-80.0000" CascadeColorEnabled="True" CascadeOpacityEnabled="True" StretchWidthEnable="False" StretchHeightEnable="False" IntelliShadingEnabled="False" ctype="SpriteObjectData">
            <Size X="224.0000" Y="224.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition />
            <PreSize X="0.0000" Y="0.0000" />
            <FileData Type="PlistSubImage" Path="fish_com12.png" Plist="Fishing/image/fishjoyol.bundle/fishres_fish_com.plist" />
            <BlendFunc Src="1" Dst="771" />
          </AbstractNodeData>
        </Children>
      </ObjectData>
    </Content>
  </Content>
</GameFile>