<GameFile>
  <PropertyGroup Name="btn_effect" Type="Node" ID="2a37a32b-e0fb-4fbf-ae20-aff44970f524" Version="3.10.0.0" />
  <Content ctype="GameProjectContent">
    <Content>
      <Animation Duration="34" Speed="0.2500" ActivedAnimationName="animation0">
        <Timeline ActionTag="1496054827" Property="Position">
          <PointFrame FrameIndex="5" X="0.0000" Y="0.0000" />
        </Timeline>
        <Timeline ActionTag="1496054827" Property="Scale">
          <ScaleFrame FrameIndex="5" X="1.0000" Y="1.0000" />
        </Timeline>
        <Timeline ActionTag="1496054827" Property="RotationSkew">
          <ScaleFrame FrameIndex="5" X="0.0000" Y="0.0000" />
        </Timeline>
        <Timeline ActionTag="303382247" Property="Position">
          <PointFrame FrameIndex="0" X="0.0000" Y="0.0000" />
          <PointFrame FrameIndex="5" X="0.0000" Y="0.0000" />
          <PointFrame FrameIndex="20" X="0.0000" Y="0.0000" />
          <PointFrame FrameIndex="32" X="0.0000" Y="0.0000" />
        </Timeline>
        <Timeline ActionTag="303382247" Property="Scale">
          <ScaleFrame FrameIndex="0" X="1.0000" Y="1.0000" />
          <ScaleFrame FrameIndex="5" X="1.0000" Y="1.0000" />
          <ScaleFrame FrameIndex="20" X="1.4500" Y="1.4500" />
          <ScaleFrame FrameIndex="32" X="1.3457" Y="1.3457" />
        </Timeline>
        <Timeline ActionTag="303382247" Property="RotationSkew">
          <ScaleFrame FrameIndex="0" X="0.0000" Y="0.0000" />
          <ScaleFrame FrameIndex="5" X="0.0000" Y="0.0000" />
          <ScaleFrame FrameIndex="20" X="0.0000" Y="0.0000" />
          <ScaleFrame FrameIndex="32" X="0.0000" Y="0.0000" />
        </Timeline>
        <Timeline ActionTag="303382247" Property="Alpha">
          <IntFrame FrameIndex="0" Value="0" />
          <IntFrame FrameIndex="5" Value="255" />
          <IntFrame FrameIndex="20" Value="0" />
          <IntFrame FrameIndex="32" Value="0" />
        </Timeline>
        <Timeline ActionTag="-818530890" Property="Position">
          <PointFrame FrameIndex="10" X="0.0000" Y="0.0000" />
          <PointFrame FrameIndex="15" X="0.0000" Y="0.0000" />
          <PointFrame FrameIndex="30" X="0.0000" Y="0.0000" />
          <PointFrame FrameIndex="34" X="0.0000" Y="0.0000" />
        </Timeline>
        <Timeline ActionTag="-818530890" Property="Scale">
          <ScaleFrame FrameIndex="10" X="1.0000" Y="1.0000" />
          <ScaleFrame FrameIndex="15" X="1.0000" Y="1.0000" />
          <ScaleFrame FrameIndex="30" X="1.4500" Y="1.4500" />
          <ScaleFrame FrameIndex="34" X="1.3457" Y="1.3457" />
        </Timeline>
        <Timeline ActionTag="-818530890" Property="RotationSkew">
          <ScaleFrame FrameIndex="10" X="0.0000" Y="0.0000" />
          <ScaleFrame FrameIndex="15" X="0.0000" Y="0.0000" />
          <ScaleFrame FrameIndex="30" X="0.0000" Y="0.0000" />
          <ScaleFrame FrameIndex="34" X="0.0000" Y="0.0000" />
        </Timeline>
        <Timeline ActionTag="-818530890" Property="Alpha">
          <IntFrame FrameIndex="10" Value="0" />
          <IntFrame FrameIndex="15" Value="255" />
          <IntFrame FrameIndex="30" Value="0" />
          <IntFrame FrameIndex="34" Value="0" />
        </Timeline>
      </Animation>
      <AnimationList>
        <AnimationInfo Name="animation0" StartIndex="0" EndIndex="34">
          <RenderColor A="255" R="141" G="73" B="45" />
        </AnimationInfo>
      </AnimationList>
      <ObjectData Name="btn_effect" ctype="GameNodeObjectData">
        <Children>
          <AbstractNodeData Name="bg" ActionTag="268623127" Tag="3" IconVisible="True" LeftMargin="-81.0000" RightMargin="-81.0000" TopMargin="-55.0000" BottomMargin="-55.0000" CascadeColorEnabled="True" CascadeOpacityEnabled="True" StretchWidthEnable="False" StretchHeightEnable="False" IntelliShadingEnabled="False" ctype="SpriteObjectData">
            <Size X="162.0000" Y="103.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition />
            <PreSize X="0.0000" Y="0.0000" />
            <FileData Type="Normal" Path="shishicai/image/tjylc_ccl_chouma.png" Plist="" />
            <BlendFunc Src="1" Dst="771" />
          </AbstractNodeData>
          <AbstractNodeData Name="Particle_1" ActionTag="1496054827" Tag="7" IconVisible="True" CascadeColorEnabled="True" CascadeOpacityEnabled="True" StretchWidthEnable="False" StretchHeightEnable="False" ctype="ParticleObjectData">
            <Size X="0.0000" Y="0.0000" />
            <AnchorPoint />
            <Position />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition />
            <PreSize X="0.0000" Y="0.0000" />
            <FileData Type="Normal" Path="shishicai/effect/ssc.plist" Plist="" />
            <BlendFunc Src="771" Dst="771" />
          </AbstractNodeData>
          <AbstractNodeData Name="tjylc_ccl_chouma2_1" ActionTag="303382247" Alpha="0" Tag="8" IconVisible="True" LeftMargin="-81.0000" RightMargin="-81.0000" TopMargin="-55.0000" BottomMargin="-55.0000" CascadeColorEnabled="True" CascadeOpacityEnabled="True" StretchWidthEnable="False" StretchHeightEnable="False" IntelliShadingEnabled="False" ctype="SpriteObjectData">
            <Size X="162.0000" Y="110.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition />
            <PreSize X="0.0000" Y="0.0000" />
            <FileData Type="Normal" Path="shishicai/image/tjylc_ccl_chouma2.png" Plist="" />
            <BlendFunc Src="1" Dst="1" />
          </AbstractNodeData>
          <AbstractNodeData Name="tjylc_ccl_chouma2_1_0" ActionTag="-818530890" Alpha="0" Tag="9" IconVisible="True" LeftMargin="-81.0000" RightMargin="-81.0000" TopMargin="-55.0000" BottomMargin="-55.0000" CascadeColorEnabled="True" CascadeOpacityEnabled="True" StretchWidthEnable="False" StretchHeightEnable="False" IntelliShadingEnabled="False" ctype="SpriteObjectData">
            <Size X="162.0000" Y="110.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition />
            <PreSize X="0.0000" Y="0.0000" />
            <FileData Type="Normal" Path="shishicai/image/tjylc_ccl_chouma2.png" Plist="" />
            <BlendFunc Src="1" Dst="1" />
          </AbstractNodeData>
        </Children>
      </ObjectData>
    </Content>
  </Content>
</GameFile>